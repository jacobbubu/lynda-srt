# Lynda-srt

Generate all of subtitle files from a course url on [lynda.com](https://lynda.com).

## Usage
```
npm i lynda-srt -g
cd path-to-subtitle
lynda-srt --username your-account --password your-password --course https://www.lynda.com/ZBrush-tutorials/ZBrush-4R8-New-Features/441599-2.html
```
** you must have a [lynda.com](https://lynda.com) account befroe run `lynda-srt`. **

or using environment variables:
```
username=your_account password=your_password your-password lynda-srt --course https://www.lynda.com/ZBrush-tutorials/ZBrush-4R8-New-Features/441599-2.html
```

You may also add a `--show` switch for showing a browser window:

```
lynda-srt --show --username your-account --password your-password --course https://www.lynda.co...
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
