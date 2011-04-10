//
//  Created by Chris Miles on 10/04/11.
//  Copyright 2011 Chris Miles. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import "IBABooleanSegmentedCell.h"
#import "IBAFormConstants.h"


@implementation IBABooleanSegmentedCell
@synthesize segmentedControl = segmentedControl_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(segmentedControl_);

	[super dealloc];
}

- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier segmentedControlLabels:(NSArray *)segmentedControlLabels {
    if ((self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier])) {
		segmentedControl_ = [[UISegmentedControl alloc] initWithItems:segmentedControlLabels];
		segmentedControl_.segmentedControlStyle = UISegmentedControlStyleBar;
		[self.cellView addSubview:segmentedControl_];
		segmentedControl_.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		segmentedControl_.frame = CGRectMake(style.valueFrame.origin.x + style.valueFrame.size.width - segmentedControl_.bounds.size.width,
											 ceil((self.bounds.size.height - segmentedControl_.bounds.size.height)/2),
											 segmentedControl_.bounds.size.width,
											 segmentedControl_.bounds.size.height);
	}
	
    return self;
}

@end
