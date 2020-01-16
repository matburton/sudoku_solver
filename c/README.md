
Bests
=====

With impossible grid based back-tracking hack and 300,000 grids in memory limit...

```
Solution:
0 1 2 3 4 5 6 7 | 8 9 A B C D E F | G H I J K L M N | O P Q R S T U V | W X Y Z a b c d | e f g h i j k l | m n o p q r s t | u v w x y z $ @
8 9 A B C D E F | u v w x y z $ @ | 0 1 2 3 4 5 6 7 | G H I J K L M N | O P Q R S T U V | W X Y Z a b c d | e f g h i j k l | m n o p q r s t
G H I J K L M N | 0 1 2 3 5 4 6 7 | m n o p q r s t | u v w x y z $ @ | 8 9 A B C D E F | P O Q R S T U V | W X Y Z a b c d | e f g h i j k l
O P Q R S T U V | G H I J K L M N | e f g h i j k l | W X Y Z a b c d | u v w x y z $ @ | m n o p q r s t | 0 1 2 3 4 5 6 7 | 8 9 A B C D E F
W X Y Z a b c d | O P Q R S T U V | 8 9 A B C D E F | e f g h i j k l | m n o p q r s t | u v w x y z $ @ | G H I J K L M N | 0 1 2 3 4 5 6 7
e f g h i j k l | W X Y Z a b c d | O P Q R S T U V | m n o p q r s t | 0 1 2 3 4 5 6 7 | 8 9 A B C D E F | u v w x y z $ @ | G H I J K L M N
m n o p q r s t | e f g h i j k l | u v w x y z $ @ | 8 9 A B C D E F | G H I J K L M N | 0 1 2 3 4 5 6 7 | O P Q R S T U V | W X Y Z a b c d
u v w x y z $ @ | m n o p q r s t | W X Y Z a b c d | 0 1 2 3 4 5 6 7 | e f g h i j k l | G H I J K L M N | 8 9 A B C D E F | O P Q R S T U V
----------------+-----------------+-----------------+-----------------+-----------------+-----------------+-----------------+----------------
1 7 0 2 3 4 5 6 | F G H I J K L 8 | g m a T Z M N 9 | p o h n b U O A | v u i q c V P B | w z j r d W Q C | x $ k s e X R D | y @ l t f Y S E
s o t n p q r m | v z u w x y 0 6 | $ D @ f L U K 8 | S Z e g 1 V N 2 | h b 7 G j 3 O M | R A T 9 H l 4 P | Y W E a B F i 5 | Q c X I d C J k
c Y d X Z e a U | j k h l g i 7 C | H J 6 4 O P t Q | M R T z E G I L | $ @ 0 m r n f S | s u v D B x 1 o | q N V b p K y 3 | 5 A W 8 9 2 F w
R W b V f Q g h | D E O M P N A B | p i q l k n r s | $ t v w x @ y u | U o 1 2 L a K 9 | X Z c Y F e 5 6 | S J 8 T d C j I | 4 7 m 0 G 3 H z
T E k j H i G x | n S U Q 3 Z R a | Y b 7 1 c V d B | J 5 9 D 0 8 F K | X p 4 A W e N C | h L t M 2 y I O | l 6 f w z m @ g | q o r u v s P $
P F J S 8 I C 9 | 2 W q X e f m p | o u j v w x y z | d k l c r B 7 6 | s t 5 D Y g Q E | b i $ @ 0 K N 3 | 1 4 G L n A H M | V Z a O R U h T
l u $ @ v y z A | V Y d b c 9 4 T | 2 S e X 5 0 h W | H C i j 3 a f s | w x 6 F Z k R I | E G m 8 J n p q | P 7 O o r U t Q | M D K L B 1 N g
M N O w B K D L | o s r t $ @ 1 5 | A F 3 C I E R G | 4 Q P X W Y m q | y z 8 H d l T J | a U V f 7 g S k | 9 2 0 c u h v Z | i b n 6 j e p x
----------------+-----------------+-----------------+-----------------+-----------------+-----------------+-----------------+----------------
2 0 T M 1 3 4 5 | a F E 6 R S p m | X c U d Y l 7 f | q g K C k W h b | H I u w G N 8 s | O j J n x B r e | i t $ P Q y 9 z | v V L o Z @ A D
v $ r q w s p 8 | i Q 0 n V 1 x y | M R N @ 6 G I Z | A L D E c P 9 U | b T t e 5 C F m | H a 4 g u d f W | K l X 2 O B Y o | h z J j 7 k 3 S
J 6 7 A e W i B | U 8 Z j z 3 P f | E g y m 2 t a v | F M O G R H 5 $ | c 4 l o D 0 1 n | I T L N h Q C p | r w S k s @ V u | b x 9 d Y X q K
S R 9 I j c t C | M J e @ L g Y $ | 3 h O Q z u b x | 7 B f d o p V n | k K r a P X i q | 2 6 E F s v G w | N 5 D H Z 8 A 0 | 1 y 4 l T W m U
X V F O m g u D | w r C W l o q h | n T P s 8 A 5 i | Q 6 3 I J 2 S 4 | p Z z v 9 f x y | U $ R t k @ Y K | d j b 1 L E 7 c | N a B e 0 M G H
Y Z K P n h x E | 4 7 T G O 5 N b | D C k r H o j q | @ w t l v u z i | L Q d $ 3 B J A | S 0 1 c V 9 y X | 6 a e U M R W m | 2 s F f 8 p g I
d a L Q o k y G | I 2 t A D H X c | 1 B W 9 $ J V K | Y r s 0 j N e m | M E @ U 7 S g 6 | 5 8 l q b 3 z Z | F T v 4 h f p x | P u C i w O n R
f b N U z l @ H | 9 B K k s u d v | F 4 L S 0 e p w | 1 T a 8 X x Z y | Y O W V 2 R h j | A D 7 P M m o i | I C 3 g G n q J | 6 $ 5 c E t r Q
----------------+-----------------+-----------------+-----------------+-----------------+-----------------+-----------------+----------------
3 2 l E P C 0 1 | d m N H 9 Y j 4 | v x G O n F 8 6 | o e J V T k A R | B D Z W u y S c | z p f X g I h L | s q r Q 7 t K a | w M $ U @ i b 5
w s x k Q R L u | 3 I S 5 0 B T G | h y K a l f 2 X | n $ b W z C t 1 | J U V E @ M 7 e | q r O d N H i 4 | o c P F Y 9 8 A | j 6 v D p g Z m
t T S v D H V r | Z p b C 1 U e J | d z 0 o B 7 4 A | j q E Y N g u I | n m a i x w 9 $ | F k 3 y G 6 8 M | X L 5 @ W 2 O R | f K h P s l Q c
i m @ z Y Z e c | q t f D 2 V g M | Q W 1 5 E R 3 T | L U G O F 7 P B | 4 6 K I N 8 j X | J b C s w A u a | H p l y 0 v h $ | n S d k o 9 x r
o p q a 5 U j y | s u i E 6 W h O | @ N M P V I C b | Z S c K d l 8 9 | r F L g k 1 t f | x Y 0 e $ 2 v Q | w B n D 3 4 m G | z J R X H 7 T A
9 A B b $ O d 4 | x w k F 7 X o P | Z Y i L g q e c | s y m @ D f r a | Q R h l z p H v | K V 5 j n E t U | C M N S I J T 6 | 3 2 0 G 1 8 W u
6 G W 7 J M f n | y $ l K 8 a r Q | s t D u m k S U | v h X H p i w x | 2 C 3 0 A O Y 5 | 1 c 9 T o P @ R | Z g d j V e z b | B N E F I q 4 L
g I 8 K h F N X | z @ n L A c v R | r w J $ p H 9 j | 2 0 4 6 M Q 3 5 | d G q b T s o P | 7 W B l Z S m D | E k u f U x 1 i | Y C e a O V t y
----------------+-----------------+-----------------+-----------------+-----------------+-----------------+-----------------+----------------
4 3 1 6 L 8 K o | N A 5 u n C H s | T E v G W g w 0 | h I R t V 9 X c | 7 i U Q m Y B Z | r M y 2 D k O S | $ d z e F l J q | p j @ b x P f a
n x D N T Y b Q | f Z V e t v @ 1 | R 5 u 6 r S J O | 3 2 d k H 0 a M | E c P y h G z L | i o s U X q F $ | j 8 W m g I 4 p | C B 7 w A K l 9
z l R 0 W @ A $ | Y O a q I h 2 w | c V x K s 9 F C | 5 7 p m L 1 b S | 3 e H j t d n o | 4 E N G P f J 8 | k i U r v M B X | T Q u g 6 y D Z
E h v F X f J e | g U W o p M K D | N k t 2 j Z A n | 6 8 x q P 4 i T | 5 r O C s 9 @ R | B Q d b l u L I | a y H 7 1 V G w | S Y 3 $ m c z 0
C O M g k V P p | c 4 6 8 m l F 0 | a 3 z 7 b d H L | B G y r Q A j e | S J X K $ q D 1 | t @ n 5 Y w T v | h u s 9 x Z 2 f | U i N E W I R o
q r G c 2 d S w | R i y $ E x b j | P Q m 8 e h B p | C N z s U F l f | I a T 4 0 W u g | 9 7 6 H 1 V Z A | n o K t @ 3 D Y | L O k v 5 J X M
j y Z H U 7 B s | k T P z r d Q 9 | i @ l I o X 1 4 | D O $ u Y J n g | N M b f v 6 w 8 | 3 m x K W p a c | R A C 5 E 0 L S | F q t V h G e 2
5 i a m t u 9 I | J L B S X 7 G 3 | q U $ M f Y D y | E W @ v Z K o w | A V F k l 2 p x | C g z 0 R h e j | c O 6 N b P Q T | r d s H n 4 8 1
----------------+-----------------+-----------------+-----------------+-----------------+-----------------+-----------------+----------------
7 j m D 0 6 W Y | A c F 1 d J Z o | C I V n M 3 u e | r s 5 4 8 t H P | q L v S Q $ G b | y N h a z O K B | T U x l X p g E | @ R i 9 k w 2 f
k d f C N S 8 T | Q V 9 a b p t n | L G H i P @ q 1 | l x 6 U B y W X | o 3 m u J K 2 h | v 4 e A r F g 5 | 7 Z R M D w I O | s E c Y z $ 0 j
r J p G s o X 3 | 7 q z m u 6 W U | l j B N T $ O E | I b C L @ d g Q | a 5 f 9 1 4 0 D | c R k i 8 Y w 2 | V F h K A H n y | Z e S M t x v P
y c U 4 b v Q M | L K $ g f e I k | x 0 R w A s m h | a V F 2 n q J D | i 8 j P 6 7 C O | o 3 p 1 E Z d u | z @ t Y 9 S 5 r | H l G T X N B W
x K z u @ t n q | 5 3 R i 4 G S X | 6 p b F Q v W a | N E 0 o w $ Y Z | l B k c M A I T | f C H 7 9 U j m | L e J 8 2 d P s | D g V 1 r h y O
A L H 9 g 2 F Z | P h s y @ 0 w Y | z K r D J 4 o 5 | c j M e O m T k | t N p n R E V U | $ I b S 6 X l x | B G 1 i f W u v | 7 3 8 C Q a d q
I 5 h 1 E w l P | B C M T N 8 O H | U 2 9 g 7 y Z Y | R i S f u v G p | z d x r e F X W | @ J q V Q t D s | 3 0 a $ c k b j | A 4 6 K L m o n
a B i e V $ R O | E l v r j 2 D x | f 8 d k t c X S | 9 3 1 7 A h K z | @ g y s w H Z Y | T P M W L G n 0 | 4 Q m 6 N q o C | I U b 5 J F u p
----------------+-----------------+-----------------+-----------------+-----------------+-----------------+-----------------+----------------
B Q P s A 0 7 i | T a 4 9 W q 5 e | I l S c R 2 v J | y Y j F 6 X 1 E | D $ M L O t m H | V w U u f C 3 g | b h p n k o d 8 | x r z @ N Z K G
V @ 3 t F 1 h W | $ 6 G N Z R J K | 7 e E y D O f r | z c u A g S Q C | T w B 5 U o q a | j x P L v 8 0 n | M s i I m Y l 2 | k p H 4 b d 9 X
D e X f R N T g | p 0 7 P k m u E | 5 d C b U B z H | w 4 n M $ I x 8 | K j S 1 V v l r | Y q W 6 A a 2 h | y 3 @ G J Q Z 9 | t F O s c o L i
H k c r x m o 2 | h M D U w t V I | 4 L Z 0 G a i g | b d 7 N f 3 q J | P Y e 6 E @ A u | Q l K z p s 9 T | 5 S F X j O C W | R 8 y n $ v 1 B
L C u 5 d E I b | @ g x 2 Y F l r | K M T A h 8 n 3 | i m H 9 t O v o | Z 0 s X p J W z | N S G k c $ B y | U V 4 q R 7 e 1 | a w D Q P f j 6
U 4 n $ 6 a q z | C d j v Q A i S | V o p W X 1 x k | K l B P s R @ r | 9 y c 8 f h 3 G | M F Z I O J 7 b | g D L u t N w H | E 5 T m 2 0 Y e
K w j l M G O J | X y 8 c B n f z | 9 6 s Y @ N Q m | V p L 5 h Z 0 W | C 2 R d F i b k | D e r 4 t o H 1 | A E T v $ a x P | g I q S U u 7 3
Z 8 y Y 9 p v S | b o 1 s H O 3 L | j q F t u w P $ | U a k T 2 e D G | g 7 n N I x 4 Q | d 5 X m @ i R E | f r B z 6 c 0 K | J h M W l A V C
----------------+-----------------+-----------------+-----------------+-----------------+-----------------+-----------------+----------------
F g 4 d 7 A H f | 6 N p 0 G s a W | w Z 8 e 3 K Y D | T u U Q 5 n B O | R h 9 z b c r 2 | k t S o I 1 V J | @ x q C P $ X L | l m j y M E i v
N S 6 o u 9 2 K | H R X O F Q y Z | k A f U 1 p G M | t D r b m c L 3 | V q C T n I d 4 | l s @ v e 0 x Y | J z j E w i a h | $ W P 7 g B 5 8
Q U 5 L I J 1 R | r b c V h w 9 i | S a X E x 6 g o | f z N $ 7 M 2 0 | j l D O B P v K | n y u C T 4 A G | t m Z W 8 s F e | d k p q 3 H @ Y
b q E 8 G P Y j | l 5 m d o I C A | B 7 c H v Q L 2 | k J V 1 9 w 4 h | f S $ @ g Z e i | 6 K D O 3 M W r | p R y 0 T u N U | X t x z F n a s
h t V i c n Z 0 | K D 3 7 T P B q | b $ 4 j F W l R | g @ 8 S e s C Y | x A E M H Q y p | L 2 a w m N X z | v I 9 d 5 1 f k | o G U r u 6 O J
p D e T O B m a | S j @ 4 M E z g | y s h q 9 C 0 I | x F W i l 6 R v | 1 k J t X u 5 3 | Z d 8 $ U 7 P H | 2 Y c A o G r n | K L f N V Q w b
$ M s y r x w v | 1 e J f U k n u | t O 5 z N i @ P | X A q a I o d H | 6 W G Y 8 m L 0 | p B F E j R b 9 | Q K 7 V l g 3 4 | c T Z 2 D S C h
@ z C W l X 3 k | t x L Y v $ 8 2 | J r n V d m T u | P K Z y G E p j | F s N 7 o U a w | g h i Q 5 c q f | D b M O H 6 S B | 9 0 1 A e R I 4

Grids in memory:              300000
Elapsed time:                 12:42:48
Grids created via splitting:  5616083
Impossible grids encountered: 4882562
Grids lost due to low memory: 433522
Solutions found:              1

Exit code      : 0
Elapsed time   : 45861.70
Kernel time    : 65.25 (0.1%)
User time      : 45520.83 (99.3%)
page fault #   : 2409477
Working set    : 4194303 KB
Paged pool     : 22 KB
Non-paged pool : 83 KB
Page file size : 4194303 KB
```