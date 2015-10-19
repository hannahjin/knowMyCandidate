# knowMyCandidate Backend

Backend for knowMyCandidate app. Handles NewsFeed generation, web scraping, and other things.

Hosted on Heroku and uses Spark web framework.

## Deployment

We want to deploy only the HerokuBackend folder, not the entire project.

```sh
git subtree push --prefix HerokuBackend heroku master
```
