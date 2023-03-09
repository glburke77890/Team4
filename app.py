from flask import Flask, render_template, request
import boto3
from datetime import datetime
import os

app = Flask(__name__)

# Configure S3 client with EC2 instance role
s3 = boto3.client('s3')

# Landing page
@app.route('/')
def index():
    return render_template('index.html')

# Contact Us form
@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        # Get form data
        name = request.form['name']
        email = request.form['email']
        message = request.form['message']

        # Save data to S3 bucket
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        data = f'{name},{email},{message},{timestamp}\n'
        s3.put_object(Body=data, Bucket=os.environ['BUCKET_NAME'], Key='contact.csv')

        return render_template('thankyou.html')
    else:
        return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True)