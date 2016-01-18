//
//  ViewController.m
//  Quiz
//
//  Created by Sandy House on 2016-01-15.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

// Keep track of what question the user is on.
@property (nonatomic) int currentQuestionIndex;

// Questions and answers
@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSArray *answers;


@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;

@end

@implementation ViewController


/* 
viewDidLoad is called exactly once, when the view controller is first loaded into memory. This is where you want to instantiate any instance variables and build any views that live for the entire lifecycle of this view controller. However, the view is usually not yet visible at this point.
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
	
	if(self) {
		//NSLog(@"Initializing questions and answers");
		// Create two arrays filled with questions and answers and make the pointers point to them
		self.questions = @[@"Who am I?",
						   @"What is 9000 + 1?",
						   @"What is the best show in the world?"];
		self.answers = @[@"The Machine",
						 @"9001",
						 @"Person of Interest"];
		
		// initialize to start with the first question
		self.currentQuestionIndex = 0;
		self.questionLabel.text = self.questions[self.currentQuestionIndex];
		
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)showQuestion:(id)sender {
	// Step to the next question
	self.currentQuestionIndex++;
	
	// Am I past the last question?
	if(self.currentQuestionIndex == [self.questions count]) {
		// Go back to the first Question
		self.currentQuestionIndex = 0;
	}
	
	// Get the string at that index in the questions array
	NSString *question = self.questions[self.currentQuestionIndex];
	
	// Display the string in the question label
	self.questionLabel.text = question;
	
	// Reset answer label
	self.answerLabel.text = @"???";
	
}

- (IBAction)showAnswer:(id)sender {
	// What is the answer to the current question?
	NSString *answer = self.answers[self.currentQuestionIndex];
	
	// Display it in the answer label
	self.answerLabel.text = answer;
}



@end
