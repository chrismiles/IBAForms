//
// Copyright 2010 Itty Bitty Apps Pty Ltd
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

#import "IBABooleanFormField.h"


@interface IBABooleanFormField () 
- (void)switchValueChanged:(id)sender;
@end


@implementation IBABooleanFormField

@synthesize switchCell = switchCell_;
@synthesize checkCell = checkCell_;
@synthesize segmentedCell = segmentedCell_;
@synthesize booleanFormFieldType = booleanFormFieldType_;
@synthesize segmentedControlLabels = segmentedControlLabels_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(switchCell_);
	IBA_RELEASE_SAFELY(checkCell_);
	IBA_RELEASE_SAFELY(segmentedCell_);
	IBA_RELEASE_SAFELY(segmentedControlLabels_);
	
	[super dealloc];
}

- (id)initWithKeyPath:(NSString *)keyPath title:(NSString *)title valueTransformer:(NSValueTransformer *)valueTransformer 
				 type:(IBABooleanFormFieldType)booleanFormFieldType {
	self = [super initWithKeyPath:keyPath title:title valueTransformer:valueTransformer];
	if (self != nil) {
		self.booleanFormFieldType = booleanFormFieldType;
	}
	
	return self;	
}

- (id)initWithKeyPath:(NSString *)keyPath title:(NSString *)title type:(IBABooleanFormFieldType)booleanFormFieldType {
	return [self initWithKeyPath:keyPath title:title valueTransformer:nil type:booleanFormFieldType];
}


#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
	IBAFormFieldCell *cell = nil;
	
	switch (self.booleanFormFieldType) {
		case IBABooleanFormFieldTypeSwitch:
			cell = [self switchCell];
			break;
		case IBABooleanFormFieldTypeCheck:
			cell = [self checkCell];
			break;
		case IBABooleanFormFieldTypeSegmented:
			cell = [self segmentedCell];
			break;
		default:
			NSAssert(NO, @"Invalid booleanFormFieldType");
			break;
	}
	
	return cell;
}

- (IBABooleanSwitchCell *)switchCell {
	if (switchCell_ == nil) {
		switchCell_ = [[IBABooleanSwitchCell alloc] initWithFormFieldStyle:self.formFieldStyle 
																		reuseIdentifier:@"IBABooleanSwitchCell"];
	
		[switchCell_.switchControl addTarget:self action:@selector(switchValueChanged:) 
									  forControlEvents:UIControlEventValueChanged];
	}
	
	return switchCell_;
}

- (IBABooleanSegmentedCell *)segmentedCell {
	if (segmentedCell_ == nil) {
		if (nil == segmentedControlLabels_) {
			self.segmentedControlLabels = [NSArray arrayWithObjects:@"NO", @"YES", nil];
		}
		segmentedCell_ = [[IBABooleanSegmentedCell alloc] initWithFormFieldStyle:self.formFieldStyle
																 reuseIdentifier:@"IBABooleanSegmentedCell"
														  segmentedControlLabels:segmentedControlLabels_];
		[segmentedCell_.segmentedControl addTarget:self action:@selector(segmentedValueChanged:) 
								  forControlEvents:UIControlEventValueChanged];
	}
	
	return segmentedCell_;
}

- (IBAFormFieldCell *)checkCell {
	if (checkCell_ == nil) {
		checkCell_ = [[IBAFormFieldCell alloc] initWithFormFieldStyle:self.formFieldStyle 
														   reuseIdentifier:@"IBABooleanCheckCell"];
	}
	
	return checkCell_;
}

- (void)updateCellContents {
	switch (self.booleanFormFieldType) {
		case IBABooleanFormFieldTypeSwitch:
		{
			self.switchCell.label.text = self.title;
			[self.switchCell.switchControl setOn:[[self formFieldValue] boolValue]];
			break;
		}
		case IBABooleanFormFieldTypeCheck:
		{
			self.checkCell.label.text = self.title;
			self.checkCell.accessoryType = ([[self formFieldValue] boolValue]) ? UITableViewCellAccessoryCheckmark : 
				UITableViewCellAccessoryNone;
			break;
		}
		case IBABooleanFormFieldTypeSegmented:
		{
			self.segmentedCell.label.text = self.title;
			[self.segmentedCell.segmentedControl setSelectedSegmentIndex:[[self formFieldValue] integerValue]];
			break;
		}
		default:
			NSAssert(NO, @"Invalid booleanFormFieldType");
			break;
	}
}

- (void)select {
	if (self.booleanFormFieldType == IBABooleanFormFieldTypeCheck) {
		[self setFormFieldValue:[NSNumber numberWithBool:![[self formFieldValue] boolValue]]];
		[self updateCellContents];
	}
}

- (void)switchValueChanged:(id)sender {
	if (sender == self.switchCell.switchControl) {
		[self setFormFieldValue:[NSNumber numberWithBool:self.switchCell.switchControl.on]];
	}
}

- (void)segmentedValueChanged:(id)sender {
	if (sender == self.segmentedCell.segmentedControl) {
		[self setFormFieldValue:[NSNumber numberWithInteger:self.segmentedCell.segmentedControl.selectedSegmentIndex]];
	}
}

@end
