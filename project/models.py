from datetime import datetime
from project import db, app, login_manager
from flask_login import UserMixin, AnonymousUserMixin


@login_manager.user_loader
def load_user(user_id):
    return Users.query.get(int(user_id))


class Anonymous(AnonymousUserMixin):
    def __init__(self):
        self.username = 'Guest'
        self.status = False


class Users(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    last_name = db.Column(db.String(30), nullable=False)
    first_name = db.Column(db.String(30), nullable=False)
    birth = db.Column(db.Date, nullable=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(60), nullable=False)
    ship_address = db.Column(db.String(120), nullable=True)
    status = db.Column(db.Boolean, default=False)
    items = db.relationship('Offer', backref='owner', lazy=True)

    user_sell = db.relationship(
        'Purchase', backref='former_owner', lazy=True, foreign_keys='Purchase.user_id')
    seller_purchase = db.relationship(
        'Purchase', backref='new_owner_seller', lazy=True, foreign_keys='Purchase.seller_id')

    user_purchase = db.relationship(
        'Sale', backref='new_owner', lazy=True, foreign_keys='Sale.user_id')
    seller_sell = db.relationship(
        'Sale', backref='former_seller_owner', lazy=True, foreign_keys='Sale.seller_id')

    def __repr__(self):
        return f"User('{self.last_name}','{self.email}','{self.items}')"


class Offer(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    details = db.Column(db.Text, nullable=True)
    price = db.Column(db.String(20), nullable=False, default='0')
    image_file = db.Column(db.String(20), nullable=False,
                           default='default.png')

    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    date_added = db.Column(db.DateTime, nullable=False,
                           default=datetime.utcnow)

    def __repr__(self):
        return f"Offered Product('{self.id}','{self.date_added}','{self.name}','{self.details}','{self.price}','{self.image_file}')"


class Sellers(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    last_name = db.Column(db.String(30), nullable=True)
    first_name = db.Column(db.String(30), nullable=False)
    birth = db.Column(db.Date, nullable=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(60), nullable=False)

    # seller_purchase = db.relationship('Purchase', backref='seller', lazy=True)
    # seller_sell = db.relationship('Sale', backref='seller', lazy=True)

    def __repr__(self):
        return f"Seller('{self.first_name}','{self.email}','{self.age}','{self.seller_purchase}','{self.seller_sell}')"


class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    details = db.Column(db.Text, nullable=True, default='None')
    image_file = db.Column(db.String(20), nullable=False,
                           default='default.png')
    bought_price = db.Column(db.String(20), nullable=False, default='0.00')

    status = db.Column(db.Boolean, nullable=False, default=False)

    sold_price = db.Column(db.String(20), nullable=True)

    purchase = db.relationship('Purchase', backref='item', uselist=False)
    sale = db.relationship('Sale', backref='item', uselist=False)

    date_added = db.Column(
        db.DateTime, nullable=False, default=datetime.utcnow)
    date_sold = db.Column(db.DateTime)

    def __repr__(self):
        if not self.status:
            return f"Product('{self.id}','{self.date_added}','{self.name}','{self.details}','{self.image_file}','{self.bought_price}')"
        else:
            return f"Product('{self.id}','{self.date_added}','{self.name}','{self.details}','{self.image_file}','{self.bought_price}','{self.sold_price}','{self.date_sold}') "


class Purchase(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    date_performed = db.Column(
        db.DateTime, nullable=False, default=datetime.utcnow)

    item_id = db.Column(db.Integer, db.ForeignKey('product.id'))
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    seller_id = db.Column(db.Integer, db.ForeignKey('users.id'))

    def __repr__(self):
        return f"Purchase('{self.date_performed}','{self.item_id}','{self.user_id}','{self.seller_id}')"


class Sale(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    date_performed = db.Column(
        db.DateTime, nullable=False, default=datetime.utcnow)

    item_id = db.Column(db.Integer, db.ForeignKey('product.id'))
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    seller_id = db.Column(db.Integer, db.ForeignKey('users.id'))

    def __repr__(self):
        return f"Purchase('{self.date_performed}','{self.item_id}','{self.user_id}','{self.seller_id}')"
