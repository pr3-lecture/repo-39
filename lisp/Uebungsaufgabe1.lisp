;gnu clisp 2.49
;@author: Stella Neser

(print "Lisp, Uebungsblatt 1!")



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

;fuer aufgabe 1
(setq x (list 1 2 3 '(4 5) 6))
;fuer aufgabe 2
(setq tree1 '(10 (5 (3) (7)) (13 (12) (20))))
;Aufgabe2
;a)
;B-Baeume sind oft verwendete unterarten von Baeumen. Die Knoten eines B-Baumes
;koennen nur max 2 Nachkommen (elemente) haben. Er besteht jewehls aus 3
;Elementen; Vater, linkes Kind, rechtes Kind. Jedes Kind kann auch ein Vater
;sein => Aufbau wird rekursiv fortgefuehrt. Man kann jedes element als Liste
;darstellen => Listern werden ineinander verzweigt, wie in einem Baum

;b)
;b.1) preorder (tree)
(defun preorder (tree)
    "PREORDER Output"
    (cond
        ((null tree) nil)
        ((listp (car tree)) (preorder (car tree)) (preorder (cdr tree)))
        (t (princ (car tree)) (princ " ") (preorder (cdr tree)))
    )
)

;b.2) inorder (tree)
(defun inorder (tree)
    "INORDER Output"
    (cond
        ( ( null tree) '() )
        ( (atom (car tree) ) (inorder (cdr tree))(princ (car tree)) (princ " ") (inorder (cddr tree)))
        (t (inorder (car tree)))
    )
)

;b.3) preorder (tree)
(defun postorder (tree)
    "POSTORDER Output"
    ;(rotieren tree)
    (inorder (cdr tree))
    (inorder (cddr tree))
    (princ (car tree))
)


(print "===")
(print "Aufgabe 1")
(print "===")
(print "")
;1a test
(print (rotieren x))
;1b test
(print (neues-vorletztes x 4))
;1c test
(print (my-length x))
;1d test
(print (my-lengthR x))
;1e test
(print (my-reverse x))
;1f test
(print (my-reverseR x))
(print "")
(print "===")
(print "Aufgabe 2")
(print "===")
(print tree1)
(print "")
;2a test
;2b test
;2b1 test
(preorder tree1)
(print "")
;(print (cdr tree1))
(inorder tree1)
;(print (rest tree1))
;(inorder (rest tree1))
(print "")
(postorder tree1)
