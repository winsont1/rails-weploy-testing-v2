[![Build Status](https://travis-ci.org/winsont1/rails-timesheets-app.svg?branch=master)](https://travis-ci.org/winsont1/rails-timesheets-app)

# Weploy Coding test

## Overview
This app allows you to record and update records of Timesheets.


## Installation Instructions
This program was coded and tested in ruby 2.5.3.
In the root folder, please run the following commands in your terminal. This will ensure bundler and all the respective gems are installed.

    $ gem install bundler
    $ bundle install

## Usage Instructions
From root folder, please key in the following command. This will create the database, run the migration files, create seeds and launch the server in your web browser in "http://localhost:3000/".

    $ rails db:create
    $ rails db:migrate
    $ rails db:seed
    $ rails s

## To do
* Build out more comprehensive tests
* Improve Front end
