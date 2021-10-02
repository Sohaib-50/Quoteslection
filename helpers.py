from functools import wraps
from flask import request, redirect, url_for, flash, session

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if session.get("user_id") is None:
            return redirect(url_for('signin', next=request.url))
        return f(*args, **kwargs)
    return decorated_function


def signin_user(user_id, username, firstname, lastname):
    session["user_id"] = user_id
    session["username"] = username
    session["firstname"] = firstname
    session["lastname"] = lastname


def signout_user():
    session.clear()


def valid_password(password):
    return len(password) > 4