FROM python:3.7

# Install manually all the missing libraries
RUN apt-get update
RUN apt-get install -y gconf-service libasound2 libatk1.0-0 libcairo2 libcups2 libfontconfig1 libgdk-pixbuf2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libxss1 fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils
RUN apt-get install libgbm1 -y

# Install Chrome
COPY bin/chromedriver /usr/bin/chromedriver
COPY bin/google-chrome-87_amd64.deb .
RUN dpkg -i google-chrome-87_amd64.deb; apt-get -fy install

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True
ENV PORT 5000

RUN pip install gunicorn

# Install Python dependencies.
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copy local code to the container image.
COPY app.py /app/app.py
ENV APP_HOME /app
WORKDIR $APP_HOME


# Run the web service on container startup.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app
