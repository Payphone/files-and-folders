;; files-and-folders.lisp

(in-package :files-and-folders)

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
  (reduce #'merge-path
          paths))

(defun filep (pathname)
  "Returns true if the pathname is a file."
  (if (pathname-name pathname) t nil))

(defun folderp (pathname)
  "Returns true if the pathname is a folder."
  (not (filep pathname)))

(defun list-all-files (directory &key (ignore-dot-files t) (max-depth nil)
                                   (include-directories t))
  "Recursively lists all files inside of a directory."
  (let (files)
    (labels ((rec (directory depth)
               (cond ((or (null directory) (if max-depth (> depth max-depth)))
                      (reverse files))
                     ((listp directory)
                      (rec (car directory) depth)
                      (rec (cdr directory) depth))
                     ((folderp directory)
                      (unless (and ignore-dot-files
                                   (char= (elt0 (last1 (pathname-directory directory))) #\.))
                        (and include-directories (= depth (1- max-depth)) (push directory files))
                        (rec (list-directory directory) (1+ depth))))
                     ((filep directory)
                      (unless (and ignore-dot-files
                                   (char= (elt0 (pathname-name directory)) #\.))
                        (push directory files))))))
      (rec (force-directory directory) -1))))

(defun shorten-directory (directory top)
  (make-pathname :host (pathname-host directory)
                 :device (pathname-device directory)
                 :directory
                 (append (collect #'symbolp (pathname-directory directory))
                         (remove-until top (pathname-directory directory)
                                       :test #'string=))
                 :name (pathname-name directory)
                 :type (pathname-type directory)
                 :version (pathname-version directory)))
