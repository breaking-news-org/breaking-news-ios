//
//
//  MIT License
//
//  Copyright (c) 2023-Present BreakingNews
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//  

import SwiftUI

struct FlexStack: Layout {
	
	public var verticalSpacing = 8.0
	
	public var horzontalSpacing = 8.0
	
	static var layoutProperties: LayoutProperties {
		var properties = LayoutProperties()
		properties.stackOrientation = .none
		return properties
	}
	
	struct CacheData {
		var matrix: [[Subviews.Element]] = [[]]
		var maxHeight: CGFloat = 0.0
	}
	
	func makeCache(subviews: Subviews) -> CacheData {
		return CacheData()
	}
	
	
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) -> CGSize {
		let matrix = getMetrix(from: subviews, in: proposal)
		cache.matrix = matrix
		
		let maxHeight = matrix.reduce(0) { $0 + getMaxHeight(of: $1) + verticalSpacing } - verticalSpacing
		
		cache.maxHeight = maxHeight
		
		return CGSize(width: proposal.width ?? .infinity, height: maxHeight)
	}
	
	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) {
		var pointer = CGPoint(x: bounds.minX, y: bounds.minY)
		for line in cache.matrix {
			line.forEach { subview in
				subview.place(at: pointer, proposal: .unspecified)
				pointer.x += subview.sizeThatFits(.unspecified).width + horzontalSpacing
			}
			pointer.x = bounds.minX
			pointer.y += getMaxHeight(of: line) + verticalSpacing
		}
	}
	
	/// Caculate the matrix of subviews
	func getMetrix(from subviews: Subviews, in proposal: ProposedViewSize) -> [[Subviews.Element]] {
		var matrixBuffer = [[]] as [[Subviews.Element]]
		
		// Flags
		let maxLineWidth = proposal.width ?? .infinity
		var lineWidthBuffer = 0.0
		var outterIndexBuffer = 0
		var isFirstOfLine = false
		
		for (_, subview) in subviews.enumerated() {
			lineWidthBuffer += subview.sizeThatFits(.unspecified).width
			
			// Handle with that the width of the first of line is wider than fmaxLineWidth
			if isFirstOfLine && lineWidthBuffer >= maxLineWidth {
				// Break line
				outterIndexBuffer += 1
				matrixBuffer.append([subview])
				lineWidthBuffer = 0.0
				isFirstOfLine = true
				continue
			}
			
			// Normal handle
			if lineWidthBuffer > maxLineWidth {
				// Break line
				outterIndexBuffer += 1
				lineWidthBuffer = subview.sizeThatFits(.unspecified).width + horzontalSpacing
				matrixBuffer.append([subview])
				isFirstOfLine = true
			} else {
				// Not break line
				matrixBuffer[outterIndexBuffer].append(subview)
				lineWidthBuffer += horzontalSpacing
				isFirstOfLine = false
			}
			
		}
		
		// print(matrixBuffer.map {$0.map { $0.sizeThatFits(.unspecified).width }})
		return matrixBuffer
	}
	
	/// Calculate max height of subviews
	func getMaxHeight(of subviews: [Subviews.Element]) -> CGFloat{
		return subviews.reduce(0) { max($0, $1.sizeThatFits(.unspecified).height) }
	}
	
}
