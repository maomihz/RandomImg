rebol [
version: 3.1.6
date: 2013-9-13
title: "random image generator"
author: "MaomiHz"
]
rig: func [{generate a random image} 
	width [integer!] "width of the image" 
	height [integer!] "height of the image" 
	blocknum [integer!] "No description" 
	/gray "generate 16-bit grayscale image (for Kindle)"
	/multi "generate multiply images"
	num [integer!] "how many images you want to generate" 
] [
	if not multi [num: 1]
	either gray [grayscale: true] [grayscale: false]
	size: copy []
	insert size height
	insert size width
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
		repeat l height [
				either l // blocknum = 1 [
					repeat m width [
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
					repeat m width [
						pair_p: to pair! reduce [m - 1 l - 2]
						pair_: to pair! reduce [m - 1 l - 1]
						img/:pair_: img/:pair_p
					]
				
				]
			]
		] [
			repeat l height [
				either l // blocknum = 1 [
					repeat m width [
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
					repeat m width [
						pair_p: to pair! reduce [m - 1 l - 2]
						pair_: to pair! reduce [m - 1 l - 1]
						img/:pair_: img/:pair_p
					]	
				]
			]
		]

		write filename encode 'bmp img
	]
	print ["complete" "generated" num "images"]
]
