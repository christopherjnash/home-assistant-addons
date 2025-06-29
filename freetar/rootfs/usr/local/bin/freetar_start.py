#!/usr/bin/env python3
import os
from flask import request, Response
import waitress
from freetar.backend import app

USERNAME = os.getenv("USERNAME")
PASSWORD = os.getenv("PASSWORD")
PORT = int(os.getenv("PORT", "22000"))

if USERNAME and PASSWORD:
    @app.before_request
    def require_auth():
        auth = request.authorization
        if not auth or not (auth.username == USERNAME and auth.password == PASSWORD):
            return Response('Authentication required', 401, {'WWW-Authenticate': 'Basic realm="Login"'})

waitress.serve(app, listen=f"0.0.0.0:{PORT}")
