# knowMyCandidate Backend

Backend for knowMyCandidate app. Handles web scraping, Twitter feed updating, and other things.

Hosted on Heroku and uses Spark web framework.

URL:
https://kmc-backend.herokuapp.com/

Config Settings:
https://kmc-backend.herokuapp.com/status

## Useful Maven commands

    mvn verify
    mvn compile
    mvn test
    # compile, test, create jar:
    mvn package
    # deploy locally:
    heroku local

## Deployment

We want to deploy only the knowMyCandidateBackend folder, not the entire project.

```sh
git subtree push --prefix knowMyCandidateBackend heroku master
```

## parse4j

https://github.com/thiagolocatelli/parse4j