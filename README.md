# TeamThrive

## Mission

[TeamThrive](https://team-thrive.org/) is an initiative aimed at alleviating
child hunger in Delaware County by providing after-school meals and culinary
arts workshops at low-income schools. In partnership with
[Philabundance](https://www.philabundance.org/) and the [Chester Education
Foundation](http://www.chestereducation.org/") (CEF), we are poised to launch
our programming at the two public high schools in Chester, Pennsylvania.
Currently, all students in the Chester Upland School District (CUSD) are
guaranteed free breakfast and lunch under the USDA's Community Eligibility
Program; however, the unavailability of a third on-campus meal highlights a
critical gap in the nutritional safety net that schools provide in low-income
areas. TeamThrive seeks to fill this gap by ensuring that all students who
attend after-school enrichment programs administered by the CEF are entitled to
a square meal during these sessions.

## App

The TeamThrive app is a virtual charity run platform which leverages the
[Strava API](https://strava.github.io/api/) in order to let users track track
their runs and bike rides using Strava, and subsequently upload those
activities to the TeamThrive database.

## Private deployment

TeamThrive is currently privately deployed on Heroku using wwwhisper. It will be
publicly released in the spring of 2017.

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```
