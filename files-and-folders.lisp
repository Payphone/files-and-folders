;; files-and-folders.lisp

(in-package :files-and-folders)

;; Utilities

(defun snoc (item list)
  (reverse (cons item (reverse list))))

(defun collect (fn lst)
  (labels ((clct (fn lst acc)
             (if lst
                 (if (funcall fn (car lst))
                     (clct fn (cdr lst) (cons (car lst) acc))
                     (clct fn (cdr lst) acc))
                 (reverse acc))))
    (clct fn lst nil)))

;; Core Functions

(defun force-directory (foldername)
  "Explicitly sets a path to be a folder."
  (let* ((folder (pathname foldername))
         (directory (pathname-directory folder))
         (name (pathname-name folder)))
    (if  directory
         (make-pathname :directory (if name (snoc name directory) directory))
         (make-pathname :directory (list :RELATIVE name)))))

(defun force-file (filename)
  "Explicitly sets a path to be a file."
  (let ((directory (pathname-directory filename)))
    (if (pathname-name filename)
        filename
        (make-pathname :directory (butlast directory)
                       :name (car (last directory))))))

(defun list-directory (folder)
  "Returns a list of files in the directory."
  (directory
   (make-pathname :type :wild :name :wild
                  :directory (pathname-directory (force-directory folder)))))

(defun merge-path (path1 path2)
  "Concatenates two path names assuming the first is always a directory."
  (make-pathname
   :directory (append (pathname-directory (force-directory path1))
                      (remove-if #'symbolp (pathname-directory path2)))
   :name (pathname-name path2)
   :type (pathname-type path2)))

(defun merge-paths (&rest paths)
  "Concatenates path names."
  (reduce #'merge-path paths))

(defun filep (pathname)
  "Returns true if the pathname is a file."
  (if (pathname-name pathname) t nil))

(defun folderp (pathname)
  "Returns true if the pathname is a folder."
  (not (filep pathname)))
