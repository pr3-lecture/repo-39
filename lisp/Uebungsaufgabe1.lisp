;gnu clisp 2.49
;@author: Stella Neser

(print "Lisp, Uebungsblatt 1!")
(setq x (list 1 2 3 '(4 5) 6))

;Aufgabe 1
;a)
(defun rotieren (x)
    "setze das erste element ans ende"
    (append (rest x) (list (first x)))
    )

;b)
(defun neues-vorletztes(a b)
    (setq newList (reverse a))
    (reverse (append (list (car newList)) (list b) (cdr newList))))


;c)
(defun my-length-cheat (x)
    "Geschumelte Version"
    (list-length x))

(defun my-length-loop (x)
    "Nicht geschumelte Version"
    (loop :for el in x  ;forEach schleife
          :counting t)) ;hochzaehlen

(defun my-length (a)
    "Laenge einer list inklusive der geschachtelten listen"
    (cond ((null a) 0)
        (t (+ 1 (my-length(rest a))))))

;d)
(defun my-lengthR (a)
    (cond ((null a) 0)
        ( (listp (car a)) (+ (my-lengthR (car a)) (my-lengthR(cdr a))))
     (t (+ 1 (my-lengthR (cdr a)))))
)

;e)
(defun my-reverse (a)
    (reverse a))
;or


;f)
(defun my-reverseR (a)
    (cond
        ((null a) '())
        ((listp(car a)) (append (my-reverseR (cdr a)) (list (my-reverseR (car a)))))
        (t (append (my-reverseR (cdr a))(list (car a))))
    )
)


;a test
(print (rotieren x))
;b test
(print (neues-vorletztes x 4))
;c test
(print (my-length x))
;d test
(print (my-lengthR x))
;e test
(print (my-reverse x))
;f test
(print (my-reverseR x))

