# cliphist-to-wofi

Utility script inspired in [cliphist contrib](https://github.com/sentriz/cliphist/blob/master/contrib/cliphist-wofi-img).

It calls `cliphist list`, filter out `<meta ..>` tags and converts each binary
(i.e., image) entry into a thumb to be stored in a temporary location. Finally,
launches wofi, captures the user selection and decode it using `cliphist` one
more time.
