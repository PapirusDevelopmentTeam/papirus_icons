from google_play_scraper import app

result = app(
    'PACKAGE',
    lang='en', # defaults to 'en'
    country='us' # defaults to 'us'
)
print(result["icon"])
