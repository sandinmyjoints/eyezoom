;;; eyezoom.el --- Eyebrowse and Zoom integration.
;;
;; Filename: eyezoom.el
;; Description: Eyebrowse and Zoom integration.
;; Author: William Bert
;; Maintainer:
;; Created: Sun Jun  2 15:06:35 2019 (-0700)
;; Version: 1.0.0
;; Package-Requires: ((emacs "26.1") (dash "20190424.1804") (eyebrowse "20190322.933") (zoom "20190523.1300"))
;; Last-Updated:
;;           By:
;;     Update #: 0
;; URL: https://github.com/sandinmyjoints/eyezoom
;; Doc URL:
;; Keywords: eyebrows, zoom, convenience
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;; Zoom and Eyebrowse are both great packages. Sometimes you may want Zoom to
;; apply only to some Eyebrowse workspaces but not others. This package lets
;; you specify the tags of which workspaces Zoom should apply to.
;;
;;; Sample usage:
;;
;; (use-package zoom)
;;
;; (use-package eyebrowse
;;   :after zoom)
;;
;; (use-package eyezoom
;;   :after eyebrowse
;;   :config
;;   (setq eyezoom-tags-that-zoom '("sql" "rest")))
;;
;; For all workspaes with tags other than "sql" and "rest", Zoom will be
;; turned off.
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change Log:
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

(require 'dash)
(require 'eyebrowse)
(require 'zoom)

(defgroup eyezoom nil
  "Eyebrowse and Zoom integration."
  :group 'tools)

(defcustom eyezoom-tags-that-zoom '()
  "Eyebrowse tags that use Zoom."
  :type 'list
  :group 'eyezoom)

(defun eyezoom/turn-off-zoom-mode (slot)
  "This is zoom--off but without the final cleanup it
    does. (Disable hooks and advice only.)"
  ;; unregister the zoom handler
  (remove-function pre-redisplay-function #'zoom--handler)
  ;; enable mouse resizing
  (advice-remove #'mouse-drag-mode-line #'ignore)
  (advice-remove #'mouse-drag-vertical-line #'ignore)
  (advice-remove #'mouse-drag-header-line #'ignore)
  (setq zoom-mode nil))

(advice-add #'eyebrowse-switch-to-window-config :before #'eyezoom/turn-off-zoom-mode)

(defun eyezoom/post-window-switch ()
  (let* ((current-slot (eyebrowse--get 'current-slot))
         (window-configs (eyebrowse--get 'window-configs))
         (current-tag (nth 2 (assoc current-slot window-configs))))
    (when (-contains? eyezoom-tags-that-zoom current-tag)
      (zoom-mode))))

(add-hook 'eyebrowse-post-window-switch-hook #'eyezoom/post-window-switch)

(provide 'eyezoom)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; eyezoom.el ends here
