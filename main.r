rebol [
version: 3.1.2
date: 2013-8-29
]
print {-}
width: ask {width? ==> }
print {}
height: ask {height? ==> }
print {}
num: to integer! ask {number? ==> }
print {}
blocknum: to integer! ask {blocknum? ==> }
grayscale_: ""
print {grayscale? (y/n)}
grayscale_: ask {if you type anything else, it will generate 256-bit RGB image ==> }
print {-}
either grayscale_ = "y" [grayscale: true] [grayscale: false]
size: copy []
insert size to integer! height
insert size to integer! width
size_: to pair! size
j: 1
repeat k num [
	until [
	filename: to file! to string! reduce [width "x" height "_" j ".bmp"]
		either ((exists? filename) = 'file) & (k = 1) [
			++ j
			print [to string! filename {has already existed}]
			false
		] [++ j true]
	]
	img: make image! size_
	either grayscale = true [
	repeat l to integer! height [
			either l // blocknum = 1 [
				repeat m to integer! width [
					either (m // blocknum) = 1 [
						ran: (random 256) - 1
						pix: to tuple! reduce [ran ran ran 0]
						pair_: to pair! reduce [m - 1 l - 1]
						img/:pair_: pix
					] [
						pair_p: to pair! reduce [m - 2 l - 1]
						pair_: to pair! reduce [m - 1 l - 1]
						img/:pair_: img/:pair_p
					]
				]
			] [
				repeat m to integer! width [
					pair_p: to pair! reduce [m - 1 l - 2]
					pair_: to pair! reduce [m - 1 l - 1]
					img/:pair_: img/:pair_p
				]
				
			]
		]
	] [
		repeat l to integer! height [
			either l // blocknum = 1 [
				repeat m to integer! width [
					either (m // blocknum) = 1 [
						pix: random 255.255.255.0
						pair_: to pair! reduce [m - 1 l - 1]
						img/:pair_: pix
					] [
						pair_p: to pair! reduce [m - 2 l - 1]
						pair_: to pair! reduce [m - 1 l - 1]
						img/:pair_: img/:pair_p
					]
				]
			] [
				repeat m to integer! width [
					pair_p: to pair! reduce [m - 1 l - 2]
					pair_: to pair! reduce [m - 1 l - 1]
					img/:pair_: img/:pair_p
				]
				
			]
		]
	]

	write filename encode 'bmp img
]
print {COMPLETE}
