import os
import secrets
from datetime import datetime
from PIL import Image
from flask import render_template, url_for, flash, redirect, request, abort
from project import app, db, bcrypt
from project.forms import (RegistrationForm, LoginForm,
                           UpdateAccountForm, OfferForm, ProductForm)
from project.models import Users, Product, Offer, Sellers, Purchase, Sale, Anonymous
from flask_login import login_user, current_user, logout_user, login_required


@app.route("/")
@app.route("/home", methods=['GET', 'POST'])
def home():
    page = request.args.get('page', 1, type=int)
    product = Product.query.filter_by(status=True, date_sold=None).order_by(
        Product.date_added.desc()).paginate(page=page, per_page=10)
    return render_template('home.html', product=product)


@app.route("/offers", methods=['GET', 'POST'])
def offers():
    if current_user.status != True:
        return redirect(url_for('home'))
    page = request.args.get('page', 1, type=int)
    offer = Offer.query.order_by(
        Offer.date_added.desc()).paginate(page=page, per_page=5)
    return render_template('offers.html', offer=offer)


@app.route("/about")
def about():
    return render_template('about.html', title='About')


@app.route("/offer/new", methods=['GET', 'POST'])
@login_required
def new_offer():
    form = OfferForm()
    if form.validate_on_submit():
        offer = Offer(name=form.name.data, details=form.details.data,
                      price=form.price.data, user_id=current_user.id)
        if form.picture.data:
            picture_file = save_picture(form.picture.data)
            offer.image_file = picture_file
        db.session.add(offer)
        db.session.commit()
        flash('Your offer has been created!', 'success')
        return redirect(url_for('home'))
    return render_template('create_offer.html', title='New Offer', form=form, legend='New Offer')


@app.route("/offer/<int:offer_id>")
def offer(offer_id):
    if current_user.status != True:
        return redirect(url_for('home'))
    offer = Offer.query.get_or_404(offer_id)
    return render_template('offer.html', title=offer.name, offer=offer)


@app.route("/offer/<int:offer_id>/delete", methods=['POST'])
@login_required
def delete_offer(offer_id):
    if current_user.status != True:
        return redirect(url_for('home'))
    offer = Offer.query.get_or_404(offer_id)
    db.session.delete(offer)
    db.session.commit()
    flash('Offer has been deleted!', 'success')
    return redirect(url_for('offers'))


@app.route("/offer/<int:offer_id>/accept", methods=['POST'])
@login_required
def accept_offer(offer_id):
    if current_user.status != True:
        return redirect(url_for('home'))
    offer = Offer.query.get_or_404(offer_id)
    newproduct = Product(name=offer.name, details=offer.details,
                         image_file=offer.image_file, bought_price=offer.price)
    db.session.add(newproduct)
    db.session.commit()
    newpurchase = Purchase(item_id=newproduct.id,
                           user_id=offer.user_id, seller_id=current_user.id)
    db.session.add(newpurchase)
    db.session.delete(offer)
    db.session.commit()
    flash('Offer has been accepted!', 'success')
    return redirect(url_for('offers'))


@app.route("/newproducts", methods=['GET', 'POST'])
def new_products():
    if current_user.status != True:
        return redirect(url_for('home'))
    page = request.args.get('page', 1, type=int)
    product = Product.query.filter_by(sold_price=None).order_by(
        Product.date_added.desc()).paginate(page=page, per_page=10)
    return render_template('newproducts.html', title='New Products', product=product)


@app.route("/product/<int:product_id>")
def product(product_id):
    prod = Product.query.get_or_404(product_id)
    return render_template('product.html', title=prod.name, prod=prod)


@app.route("/product/<int:product_id>/update", methods=['GET', 'POST'])
@login_required
def update_product(product_id):
    if current_user.status != True:
        return redirect(url_for('home'))
    prod = Product.query.get_or_404(product_id)
    form = ProductForm()
    if form.validate_on_submit():
        prod.name = form.name.data
        prod.details = form.details.data
        prod.sold_price = form.price.data
        prod.status = True
        if form.picture.data:
            picture_file = save_picture(form.picture.data)
            prod.image_file = picture_file
        db.session.commit()
        flash('Product has been updated!', 'success')
        return redirect(url_for('product', product_id=prod.id))
    elif request.method == 'GET':
        form.name.data = prod.name
        form.details.data = prod.details
        # if prod.sold_price:
        #     form.price.data = prod.sold_price
        form.picture.data = prod.image_file
    return render_template('create_offer.html', title='Update Product', legend='Update Product', form=form)


@app.route("/product/<int:product_id>/buy", methods=['POST'])
def buy_product(product_id):
    prod = Product.query.get_or_404(product_id)
    # date = datetime.utcnow()
    prod.date_sold = datetime.utcnow()
    db.session.commit()
    purchaseindex = Purchase.query.filter_by(item_id=prod.id).first()
    newsale = Sale(item_id=prod.id, user_id=current_user.id,
                   seller_id=purchaseindex.seller_id)
    db.session.add(newsale)
    db.session.commit()
    flash('Product bought!', 'success')
    return redirect(url_for('home'))


@app.route("/stats")
def stats():
    if current_user.status != True:
        return redirect(url_for('home'))
    workers = Users.query.filter_by(status=True).order_by(Users.id).all()

    for worker in workers:
        worker.purchases = Purchase.query.filter_by(
            seller_id=worker.id).order_by(Purchase.item_id).all()
        worker.sales = Sale.query.filter_by(
            seller_id=worker.id).order_by(Sale.item_id).all()
        worker.overall_worker_bought_price = 0
        worker.overall_worker_sell_price = 0
        for purchase in worker.purchases:
            worker.overall_worker_bought_price += int(
                purchase.item.bought_price)
        for sale in worker.sales:
            worker.overall_worker_sell_price += int(sale.item.sold_price)
        worker.usefulness_raznitsa = worker.overall_worker_sell_price - \
            worker.overall_worker_bought_price
        worker.usefulness_razi = worker.overall_worker_sell_price / \
            worker.overall_worker_bought_price
        worker.usefulness_percent = 100/worker.overall_worker_bought_price * \
            worker.overall_worker_sell_price - 100
    return render_template('stats.html', workers=workers)


@app.route("/register", methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    form = RegistrationForm()
    if form.validate_on_submit():
        hashed_password = bcrypt.generate_password_hash(
            form.password.data).decode('utf-8')
        user = Users(last_name=form.last_name.data, first_name=form.first_name.data, birth=form.birth.data,
                     ship_address=form.address.data, email=form.email.data, password=hashed_password)
        db.session.add(user)
        db.session.commit()
        flash('Your account has been created! You are now able to log in', 'success')
        return redirect(url_for('login'))
    return render_template('register.html', title='Register', form=form)


@app.route("/login", methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    form = LoginForm()
    if form.validate_on_submit():
        user = Users.query.filter_by(email=form.email.data).first()
        if user and bcrypt.check_password_hash(user.password, form.password.data):
            login_user(user, remember=form.remember.data)
            next_page = request.args.get('next')
            return redirect(next_page) if next_page else redirect(url_for('home'))
        else:
            flash('Login Unsuccessful. Please check email and password', 'danger')
    return render_template('login.html', title='Login', form=form)


@app.route("/logout")
def logout():
    logout_user()
    return redirect(url_for('home'))


def save_picture(form_picture):
    random_hex = secrets.token_hex(8)
    _, f_ext = os.path.splitext(form_picture.filename)
    picture_fn = random_hex + f_ext
    picture_path = os.path.join(
        app.root_path, 'static/prod_pics', picture_fn)

    output_size = (500, 500)
    i = Image.open(form_picture)
    i.thumbnail(output_size)
    i.save(picture_path)

    return picture_fn


@app.route("/account", methods=['GET', 'POST'])
@login_required
def account():
    form = UpdateAccountForm()
    if form.validate_on_submit():
        current_user.last_name = form.last_name.data
        current_user.first_name = form.first_name.data
        current_user.birth = form.birth.data
        current_user.ship_address = form.address.data
        current_user.email = form.email.data
        db.session.commit()
        flash('Your account has been updated!', 'success')
        return redirect(url_for('account'))
    elif request.method == 'GET':
        form.last_name.data = current_user.last_name
        form.first_name.data = current_user.first_name
        form.birth.data = current_user.birth
        form.address.data = current_user.ship_address
        form.email.data = current_user.email
    return render_template('account.html', title='Account', form=form)
