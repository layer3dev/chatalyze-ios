//
//  ExtensionHelper.swift
//  Tamvoes
//
//  Created by Developer on 24/05/21.
//

import UIKit

public class DynamicSizeTableView: UITableView
{
    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    override public var intrinsicContentSize: CGSize {
        return contentSize
    }
}

public class DynamicSizeCollectionView: UICollectionView
{
    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    override public var intrinsicContentSize: CGSize {
        return contentSize
    }
}
