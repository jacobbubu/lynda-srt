# Lynda-srt

Generate all of subtitle files from a course url on [lynda.com](https://lynda.com).

## Usage
```
npm i lynda-srt -g
cd path-to-subtitle
lynda-srt --lyndauser your-account --lyndapass your-password --course https://www.lynda.com/ZBrush-tutorials/ZBrush-4R8-New-Features/441599-2.html
```
** you must have a [lynda.com](https://lynda.com) account befroe run `lynda-srt`. **

or using environment variables:
```
lyndauser=your_account lyndapass=your_password your-lyndapass lynda-srt --course https://www.lynda.com/ZBrush-tutorials/ZBrush-4R8-New-Features/441599-2.html
```

You may also add a `--show` switch for showing a browser window:

```
lynda-srt --show --lyndauser your-account --lyndapass your-password --course https://www.lynda.co...
```

Output:
```
Continuing a stroke.srt
Setting up Live Booleans.srt
Transposing multiple subtools at once.srt
What you should know before watching this course.srt
...
...
ZBrush 4R8 New Features.m3u
```

A playlist file('ZBrush 4R8 New Features.m3u') has been generated too that uses the course title as the file name.
