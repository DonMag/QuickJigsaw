//
//  ViewController.swift
//  QuickJigsaw
//
//  Created by Don Mag on 6/6/24.
//

import UIKit

enum PuzzlePieceEdge {
	case flat, notch, tab
}
struct PuzzlePieceEdges {
	var left: PuzzlePieceEdge = .flat
	var top: PuzzlePieceEdge = .flat
	var right: PuzzlePieceEdge = .flat
	var bottom: PuzzlePieceEdge = .flat
}

class PuzzlePiece: UIView {
	
	// final position of this view
	public var targetOrigin: CGPoint = .zero
	
	// how close to final position to be "successful"
	public var proximity: CGFloat = 20.0
	
	// flats, tabs or notches
	public var edges: PuzzlePieceEdges = PuzzlePieceEdges()
	
	public var image: UIImage? {
		didSet {
			if let image {
				pieceImageLayer.contents = image.cgImage
			}
		}
	}
	
	public var imagePosition: CALayerContentsGravity = .center {
		didSet {
			var actualGravity: CALayerContentsGravity = imagePosition
			// gravity Y is inverted
			switch imagePosition {
			case .topLeft:
				actualGravity = .bottomLeft
			case .topRight:
				actualGravity = .bottomRight
			case .bottomLeft:
				actualGravity = .topLeft
			case .bottomRight:
				actualGravity = .topRight
			default:
				()
			}
			pieceImageLayer.contentsGravity = actualGravity
		}
	}
	
	// size of notch or tab
	public var notchPct: CGFloat = 0.4
	
	// size of "gap" at base of notch or tab
	public var edgePct: CGFloat = 0.1
	
	private let pieceImageLayer = CALayer()
	private let pieceOutlineLayer = CAShapeLayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		pieceOutlineLayer.strokeColor = UIColor.black.cgColor
		pieceOutlineLayer.fillColor = UIColor.clear.cgColor
		pieceOutlineLayer.lineWidth = 1
		
		layer.addSublayer(pieceImageLayer)
		layer.addSublayer(pieceOutlineLayer)
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let notch: CGFloat = bounds.width * notchPct
		let edge: CGFloat = bounds.width * edgePct
		
		var pt: CGPoint = .zero
		var pt1: CGPoint = .zero
		var pt2: CGPoint = .zero
		
		let pth = UIBezierPath()
		
		pth.move(to: bounds.topLeft)
		
		switch edges.top {
		case .tab:
			pt = bounds.topCenter
			pt.x -= edge
			pth.addLine(to: pt)
			pt = bounds.topCenter
			pt1 = pt
			pt2 = pt
			pt.x += edge
			pt1.x -= notch
			pt1.y -= notch
			pt2.x += notch
			pt2.y -= notch
			pth.addCurve(to: pt, controlPoint1: pt1, controlPoint2: pt2)
			pth.addLine(to: bounds.topRight)
			()
			
		case .notch:
			pt = bounds.topCenter
			pt.x -= edge
			pth.addLine(to: pt)
			pt = bounds.topCenter
			pt1 = pt
			pt2 = pt
			pt.x += edge
			pt1.x -= notch
			pt1.y += notch
			pt2.x += notch
			pt2.y += notch
			pth.addCurve(to: pt, controlPoint1: pt1, controlPoint2: pt2)
			pth.addLine(to: bounds.topRight)
			()
			
		default:
			pth.addLine(to: bounds.topRight)
			()
		}
		
		switch edges.right {
		case .tab:
			pt = bounds.centerRight
			pt.y -= edge
			pth.addLine(to: pt)
			pt = bounds.centerRight
			pt1 = pt
			pt2 = pt
			pt.y += edge
			pt1.x += notch
			pt1.y -= notch
			pt2.x += notch
			pt2.y += notch
			pth.addCurve(to: pt, controlPoint1: pt1, controlPoint2: pt2)
			pth.addLine(to: bounds.bottomRight)
			()
			
		case .notch:
			pt = bounds.centerRight
			pt.y -= edge
			pth.addLine(to: pt)
			pt = bounds.centerRight
			pt1 = pt
			pt2 = pt
			pt.y += edge
			pt1.x -= notch
			pt1.y -= notch
			pt2.x -= notch
			pt2.y += notch
			pth.addCurve(to: pt, controlPoint1: pt1, controlPoint2: pt2)
			pth.addLine(to: bounds.bottomRight)
			()
			
		default:
			pth.addLine(to: bounds.bottomRight)
			()
		}
		
		switch edges.bottom {
		case .tab:
			pt = bounds.bottomCenter
			pt.x += edge
			pth.addLine(to: pt)
			pt = bounds.bottomCenter
			pt1 = pt
			pt2 = pt
			pt.x -= edge
			pt1.x += notch
			pt1.y += notch
			pt2.x -= notch
			pt2.y += notch
			pth.addCurve(to: pt, controlPoint1: pt1, controlPoint2: pt2)
			pth.addLine(to: bounds.bottomLeft)
			()
			
		case .notch:
			pt = bounds.bottomCenter
			pt.x += edge
			pth.addLine(to: pt)
			pt = bounds.bottomCenter
			pt1 = pt
			pt2 = pt
			pt.x -= edge
			pt1.x += notch
			pt1.y -= notch
			pt2.x -= notch
			pt2.y -= notch
			pth.addCurve(to: pt, controlPoint1: pt1, controlPoint2: pt2)
			pth.addLine(to: bounds.bottomLeft)
			()
			
		default:
			pth.addLine(to: bounds.bottomLeft)
			()
		}
		
		switch edges.left {
		case .tab:
			pt = bounds.centerLeft
			pt.y += edge
			pth.addLine(to: pt)
			pt = bounds.centerLeft
			pt1 = pt
			pt2 = pt
			pt.y -= edge
			pt1.x -= notch
			pt1.y += notch
			pt2.x -= notch
			pt2.y -= notch
			pth.addCurve(to: pt, controlPoint1: pt1, controlPoint2: pt2)
			pth.addLine(to: bounds.topLeft)
			()
			
		case .notch:
			pt = bounds.centerLeft
			pt.y += edge
			pth.addLine(to: pt)
			pt = bounds.centerLeft
			pt1 = pt
			pt2 = pt
			pt.y -= edge
			pt1.x += notch
			pt1.y += notch
			pt2.x += notch
			pt2.y -= notch
			pth.addCurve(to: pt, controlPoint1: pt1, controlPoint2: pt2)
			pth.addLine(to: bounds.topLeft)
			()
			
		default:
			pth.addLine(to: bounds.topLeft)
			()
		}
		
		pth.close()
		
		pieceImageLayer.frame = bounds
		let msk = CAShapeLayer()
		// any opaque color for the mask
		msk.fillColor = UIColor.red.cgColor
		msk.path = pth.cgPath
		pieceImageLayer.mask = msk
		
		pieceOutlineLayer.path = pth.cgPath
		
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = .zero
		layer.shadowOpacity = 0.0
		layer.shadowRadius = 2.0
		
	}
	
	// to track dragging
	private var touchStartPT: CGPoint = .zero
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let t = touches.first else { return }
		self.transform = .identity
		// show shadow
		layer.shadowOpacity = 1.0
		if let sv = superview {
			sv.bringSubviewToFront(self)
		}
		touchStartPT = t.location(in: self)
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let t = touches.first else { return }
		let newPT = t.location(in: self)
		self.frame.origin.x += newPT.x - touchStartPT.x
		self.frame.origin.y += newPT.y - touchStartPT.y
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if abs(self.frame.origin.x - targetOrigin.x) < proximity && abs(self.frame.origin.y - targetOrigin.y) < proximity {
			// "dropped" this piece within proximity of target point
			// move to actual target point
			self.frame.origin = targetOrigin
			// hide shadow
			layer.shadowOpacity = 0.0
		}
	}
}

// ----------------------------------

class JigsawVC: UIViewController {
	
	let gameOutline = UIView()
	
	var pieces: [PuzzlePiece] = []
	
	let gameSize: CGSize = .init(width: 240.0, height: 240.0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let img = UIImage(named: "test320x320") else {
			fatalError("Could not load image!!!")
		}
		
		var scaledImage: UIImage = img
		
		// scale image if needed
		if img.size != gameSize {
			let fmt = UIGraphicsImageRendererFormat()
			fmt.scale = 1
			let rndr = UIGraphicsImageRenderer(size: gameSize, format: fmt)
			scaledImage = rndr.image { ctx in
				img.draw(in: .init(origin: .zero, size: gameSize))
			}
		}
		
		gameOutline.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
		gameOutline.frame = .init(origin: .zero, size: gameSize)
		view.addSubview(gameOutline)
		
		// create 4 puzzle pieces
		for _ in 1...4 {
			let p = PuzzlePiece()
			view.addSubview(p)
			p.frame = .init(x: 0.0, y: 0.0, width: gameSize.width * 0.5, height: gameSize.height * 0.5)
			p.image = scaledImage
			pieces.append(p)
		}
		
		var p: PuzzlePiece!
		
		// set positions and flats / notches / tabs
		
		p = pieces[0]
		p.imagePosition = .topLeft
		p.edges = PuzzlePieceEdges(right: .notch, bottom: .notch)
		
		p = pieces[1]
		p.imagePosition = .topRight
		p.edges = PuzzlePieceEdges(left: .tab, bottom: .notch)
		
		p = pieces[2]
		p.imagePosition = .bottomLeft
		p.edges = PuzzlePieceEdges(top: .tab, right: .tab)
		
		p = pieces[3]
		p.imagePosition = .bottomRight
		p.edges = PuzzlePieceEdges(left: .notch, top: .tab)
		
	}
	
	var firstLayout: Bool = true
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		// on first layout, we need to position the UI elements
		if firstLayout {
			firstLayout = false
			
			// position the "game frame"
			gameOutline.frame.origin.y = view.safeAreaInsets.top + 20.0
			gameOutline.center.x = view.center.x
			
			// let's just put the 4 pieces below the game frame
			//	scaled to 50% so they all fit
			
			var x: CGFloat!
			var y: CGFloat!
			
			y = gameOutline.frame.maxY + 160.0
			
			x = view.bounds.width * 0.3
			pieces[3].center = .init(x: x, y: y)
			
			x = view.bounds.width * 0.7
			pieces[2].center = .init(x: x, y: y)
			
			y += 120.0
			
			x = view.bounds.width * 0.3
			pieces[1].center = .init(x: x, y: y)
			
			x = view.bounds.width * 0.7
			pieces[0].center = .init(x: x, y: y)
			
			for v in pieces.reversed() {
				v.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
			}
			
			// set target positions for the 4 pieces
			for v in pieces {
				switch v.imagePosition {
				case .topLeft:
					v.targetOrigin = gameOutline.frame.topLeft
				case .topRight:
					v.targetOrigin = gameOutline.frame.topCenter
				case .bottomLeft:
					v.targetOrigin = gameOutline.frame.centerLeft
				case .bottomRight:
					v.targetOrigin = gameOutline.frame.center
				default:
					()
				}
			}
			
		}
		
	}
	
}


/*
 
 erica sadun, ericasadun.com
 Core Geometry

 https://gist.github.com/erica/72cce9a0444e7f5d5db0d328aeca1f5a
 
 */

extension CGRect {
	/// Sets and returns top left corner
	public var topLeft: CGPoint {
		get { return origin }
		set { origin = newValue }
	}
	
	/// Sets and returns top center point
	public var topCenter: CGPoint {
		get { return CGPoint(x: midX, y: minY) }
		set { origin = CGPoint(x: newValue.x - width / 2,
							   y: newValue.y) }
	}
	
	/// Returns top right corner
	public var topRight: CGPoint {
		get { return CGPoint(x: maxX, y: minY) }
		set { origin = CGPoint(x: newValue.x - width,
							   y: newValue.y) }
	}
	
	/// Returns center left point
	public var centerLeft: CGPoint {
		get { return CGPoint(x: minX, y: midY) }
		set { origin = CGPoint(x: newValue.x,
							   y: newValue.y - height / 2) }
	}
	
	/// Sets and returns center point
	public var center: CGPoint {
		get { return CGPoint(x: midX, y: midY) }
		set { origin = CGPoint(x: newValue.x - width / 2,
							   y: newValue.y - height / 2) }
	}
	
	/// Returns center right point
	public var centerRight: CGPoint {
		get { return CGPoint(x: maxX, y: midY) }
		set { origin = CGPoint(x: newValue.x - width,
							   y: newValue.y - height / 2) }
	}
	
	/// Returns bottom left corner
	public var bottomLeft: CGPoint {
		get { return CGPoint(x: minX, y: maxY) }
		set { origin = CGPoint(x: newValue.x,
							   y: newValue.y - height) }
	}
	
	/// Returns bottom center point
	public var bottomCenter: CGPoint {
		get { return CGPoint(x: midX, y: maxY) }
		set { origin = CGPoint(x: newValue.x - width / 2,
							   y: newValue.y - height) }
	}
	
	/// Returns bottom right corner
	public var bottomRight: CGPoint {
		get { return CGPoint(x: maxX, y: maxY) }
		set { origin = CGPoint(x: newValue.x - width,
							   y: newValue.y - height) }
	}
}
