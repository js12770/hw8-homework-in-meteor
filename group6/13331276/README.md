# SE-386 Lab 08. MyHomework

## install & start development
1. Install Meteor
2. In the same path of this file, run: Meteor
3. Type localhost:3000 in your broswer's addressbar
4. Enjoy!

## This meteor project depends on mquandalle:jade
## You may need add mquandalle:jade to project before run it

## What's New
1.Teacher can now give score to student even before deadline if 'allow score before dealine' is selected, but teacher can not give a score if it isn't selected
2.If a score is given to student before deadline,any new submit will result in 'none' score status

## Problem Remain
1.Any input will not be justified, which means any input(even empty) will be recognized as valid

## Other
1.The 'insecure' package isn't removed, cause it insecure in some situation, but it is good for development.Before you deploy the app, you might wish to remove it(run meteor remove insecure).Generally, you would not need to do anything else, but I am not so sure.
2.Please report bug to wuwy23@mail2.sysu.edu.cn