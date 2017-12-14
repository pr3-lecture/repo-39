
;a tree is defined as followed
;car tree -> value of node
;cadr tree -> left tree
;caddr tree -> right tree
(defvar tree1 nil)
(defvar l '())
(defvar l2 '())

;tree helpers
;get currentValue
(defun currentVal (tree)
  (car tree))

;left branch
(defun left (tree)
  (cadr tree))

;right branch
(defun right (tree)
  (caddr tree))

;create a node 
(defun node (val l r)
  (list val l r))

;insert into tree
(defun insert (tree val)
  (cond
    ((null tree) (node val nil nil)) ;if tree is empty
    ((= val (currentVal tree)) tree) ;if the currentVal is the value to be inputed, no further action is needed
    ((< val (currentVal tree))       ;if val is smaller than root, insert on left side
     (node 
       ( currentVal tree )
       ( insert (left tree) val ) ;insert on left
       ( right tree)
       )
     )
    ((> val (currentVal tree))       ;if val is greater than currentVal, insert on right side
     (node
       ( currentVal tree)
       ( left tree)
       ( insert (right tree) val)    ;insert on right
       )
     )

    ))

;helper, create tree from list
(defun newTree (elements)
  (let (tree))
  (dolist (e elements) (setf tree1 (insert tree1 e)))
  )

(defun newTree2 (elements)
  (setq tree '())
    (dolist (e elements) (setf tree (insert tree e))
    )
    tree
  )

(defun contains (tree val)
  (cond
    ( (null tree) nil ) ;empty tree
    ( (< val (currentVal tree) ) 
      (contains  (left tree) val  )
    ); check left
    ( (> val (currentVal tree) ) 
      (contains (right tree) val )
    ); check right
    ( (= val (currentVal tree) )
    )
   )
  )

(defun flatten (l)
  (cond ((null l) nil)
        ((atom l) (list l))
        (t (loop for e in l append( flatten e)))))

(defun getMin (tree)
    (apply #'min (flatten tree))
  )

;working only with nodes at the moment
(defun doRemoveVal (tree val)
  (setq temp tree)
  (print "Removing")
        (cond
          (
           (< val (currentVal tree)) 
           (remove (right ) tree)
           (doRemoveVal (left tree) val)
          )
          (
           (> val (currentVal tree)) 
           (print "larger")
           (doRemoveVal (right tree) val)
           )
          ( 
            (= val (currentVal tree)) 
            (print "found")
           (setf (car tree) (getMin (right tree))) 
           (setf (cadr tree) nil)
           (setf (caddr tree) nil)
           )
     )
  (print tree)
  )

(defun removeVal (tree val)
  (if (contains tree val)
    (doRemoveVal tree val)
  ))


(defun getMax (tree)
    (apply #'max (flatten tree))
  )

(defun isEmpty (tree)
  (cond
    ((null tree) t)
    (t nil)
    )
  )

;TODO
;(defun readFile (filename)
;    (with-open-file (in filename :direction :input)
;      (loop for line = (read-line in nil)
;      :while line
;      :collect (mapcar #'parse-integer (split line))
;        )
;      )
;  )

;helper: convert lines to list

(defun size (tree)
    (cond
     ((null tree) 0)
     ((< (list-length(flatten (left tree))) (list-length(flatten (right tree)))) (+ 1 (list-length(flatten (right tree)))))
     ((> (list-length(flatten (left tree))) (list-length(flatten (right tree)))) (+ 1 (list-length(flatten (left tree)))))
     ((= (list-length(flatten (left tree))) (list-length(flatten (right tree)))) (+ 1 (list-length(flatten (left tree)))))
     )
  )

(defun levelOrderHelper (l1 l2)
  (flatten (map-into l1 #'list l1 l2))
)

(defun printLevelOrder (tree)
    ( print  
      (append (list (car tree))
      (levelOrderHelper 
        (flatten (left tree) ) 
        (flatten (right tree) )
      )
      )
    )
)


;(print "testing Helpers")

(print "create a null tree")
;(setf tree nil)
(print tree1)

(print "adding elements")
(setq l (list 23 12 1 4 5 28 4 9 10 45 89))
;(setq l2 (list 123 212 31 44 55 628 74 89 910 345 589))
(print l)
(print l2)


(print "create tree")
;(newTree l)
(setq tree1 (newTree2 l))

(print "show tree")
(print tree1)

(print "contains 145; expected nil")
(print (contains tree1 145))


(print "contains 45; expected t")
(print (contains tree1 45))

(print "insert 145")
(setq tree1 (insert tree1 145))

(print "show tree")
(print tree1)

(print "contains 145; expected t")
(print (contains tree1 145))

(print "removing 28")
(removeVal tree1 28)
(print tree1)

(print "contains 28; expected nil")
(print (contains tree1 28))

(print "getMin; expected 1")
(print (getMin tree1))

(print "getMax; expected 145")
(print (getMax tree1))


(print "size; expected 7")
(print (size tree1))


(print "level order")
(printLevelOrder tree1)

(print "isEmpty; expected nil")
(print (isEmpty tree1))

(print "isEmpty '(); expected t")
(print (isEmpty '()))
