from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileAllowed
from flask_login import current_user
from wtforms import StringField, PasswordField, SubmitField, BooleanField, TextAreaField, DecimalField
from wtforms.fields.html5 import DateField
from wtforms.validators import DataRequired, Length, Email, EqualTo, ValidationError
from project.models import Users


class RegistrationForm(FlaskForm):
    last_name = StringField('Last name', validators=[
                            DataRequired(), Length(min=2, max=20)])
    first_name = StringField('First name', validators=[
                             DataRequired(), Length(min=2, max=20)])
    birth = DateField('Date of birth')
    address = TextAreaField('Shipping address', validators=[DataRequired()])
    email = StringField('Email',
                        validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])
    confirm_password = PasswordField('Confirm Password',
                                     validators=[DataRequired(), EqualTo('password')])
    submit = SubmitField('Sign Up')

    def validate_email(self, email):
        user = Users.query.filter_by(email=email.data).first()
        if user:
            raise ValidationError(
                'That email is taken. Please choose a different one.')


class LoginForm(FlaskForm):
    email = StringField('Email',
                        validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])
    remember = BooleanField('Remember Me')
    submit = SubmitField('Login')


class OfferForm(FlaskForm):
    name = StringField('Name', validators=[DataRequired()])
    details = TextAreaField('Details', validators=[DataRequired()])
    price = DecimalField('Price', validators=[DataRequired()])
    picture = FileField('Add picture', validators=[
                        FileAllowed(['jpg', 'png'])])
    submit = SubmitField('Send')


class ProductForm(FlaskForm):
    name = StringField('Name', validators=[DataRequired()])
    details = TextAreaField('Details', validators=[DataRequired()])
    picture = FileField('Edit picture', validators=[
                        FileAllowed(['jpg', 'png'])])
    price = DecimalField('Price', validators=[DataRequired()])
    submit = SubmitField('Accept')


class UpdateAccountForm(FlaskForm):
    last_name = StringField('Last name', validators=[
                            DataRequired(), Length(min=2, max=20)])
    first_name = StringField('First name', validators=[
                             DataRequired(), Length(min=2, max=20)])
    birth = DateField('Date of birth')
    address = TextAreaField('Shipping address', validators=[DataRequired()])
    email = StringField('Email', validators=[DataRequired(), Email()])
    submit = SubmitField('Update')

    def validate_email(self, email):
        if email.data != current_user.email:
            user = Users.query.filter_by(email=email.data).first()
            if user:
                raise ValidationError(
                    'That email is taken. Please choose a different one.')
