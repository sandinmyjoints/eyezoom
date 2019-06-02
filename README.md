# eyezoom

[Zoom](https://github.com/cyrus-and/zoom) and
[Eyebrowse](https://github.com/wasamasa/eyebrowse) are both great packages.
Sometimes you may want Zoom to apply only to some Eyebrowse workspaces but not
others. This package lets you specify the tags of which workspaces Zoom should
apply to.

## Sample usage:

``` emacs-lisp
(use-package zoom)

(use-package eyebrowse
  :after zoom)

(use-package eyezoom
  :after eyebrowse
  :config
  (setq eyezoom-tags-that-zoom '("sql" "rest")))
```

For all workspaes with tags other than "sql" and "rest", Zoom will be turned
off.
