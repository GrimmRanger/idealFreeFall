//
//  ViewController.m
//  idealFreefall
//
//  Created by Frank Grimmer on 2/12/12.
//  Copyright (c) 2012 Viscereality . All rights reserved.
//

#import "ViewController.h"

@interface ViewController()
- (void)updateForPTMRatio;
- (void)updateKinematicsForBodyView:(UIView *)physicalView;
- (void)createPhysicsWorld;
- (void)addPhysicalBodyForView:(UIView *)physicalView;
- (void)tick:(NSTimer *)timer;
@end

@implementation ViewController

@synthesize world = _world;
@synthesize tickTimer = _tickTimer;
@synthesize tennisBall = _tennisBall;

@synthesize resetButton = _resetButton;
@synthesize threeQuarterLabel = _threeQuarterLabel;
@synthesize halfLabel = _halfLabel;
@synthesize quarterLabel = _quarterLabel;
@synthesize verticalVelocityLabel = _verticalVelocityLabel;
@synthesize maxVerticalVelocityLabel = _maxVerticalVelocityLabel;

@synthesize yi = _yi;
@synthesize d = _d;
@synthesize vyi2 = _vyi2;
@synthesize dy = _dy;
@synthesize vyf2 = _vyf2;
@synthesize vyf = _vyf;

static float ballDimension = 0.0;
static float maxVerticalVelocity = 0.0;


#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{	
    [super viewDidLoad];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	
	[self updateForPTMRatio];
	
	[self createPhysicsWorld];
	
	[self addPhysicalBodyForView:self.tennisBall];
	
	
	/*
	for (UIView *oneView in self.view.subviews)
	{
		[self addPhysicalBodyForView:oneView];
	}*/
	
	self.tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
	
	//Configure and start accelerometer
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60.0)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark ViewController()

- (void)updateForPTMRatio
{
	float totalHeight = self.view.frame.size.height / PTM_RATIO;
	NSString *threeQuarterString = [NSString stringWithFormat:@"%.2f", 0.75 * totalHeight];
	NSString *halfString = [NSString stringWithFormat:@"%.2f", 0.5 * totalHeight];
	NSString *quarterString = [NSString stringWithFormat:@"%.2f", 0.25 * totalHeight];
	
	[self.threeQuarterLabel setText:threeQuarterString];
	[self.halfLabel setText:halfString];
	[self.quarterLabel setText:quarterString];
	
	//ballDimension = 36 / totalHeight;
	ballDimension = 0.07 * PTM_RATIO;
	CGRect frame = CGRectMake((self.view.frame.size.width - ballDimension)/2,
							  0, ballDimension, ballDimension);
	[self.tennisBall setFrame:frame];
}

- (void)updateKinematicsForBodyView:(UIView *)physicalView
{
	b2Body *b = (b2Body*)physicalView.tag;
	//b2Body *b = (__bridge b2Body*)physicalView;
	b2Vec2 linearVelocity = b->GetLinearVelocity();
	
	float yi = (self.view.frame.size.height - physicalView.frame.origin.y - 2*ballDimension) / PTM_RATIO;
	float vyi2 = (linearVelocity.y * linearVelocity.y);
	float dy = (0.0 - yi);
	float vyf2 = vyi2 + (2 * -9.8 * dy);
	float vyf = sqrtf(vyf2);
	
	[self.yi setText:[NSString stringWithFormat:@"%.2f", yi]];
	[self.vyi2 setText:[NSString stringWithFormat:@"%.2f", vyi2]];
	[self.dy setText:[NSString stringWithFormat:@"%.2f", dy]];
	[self.d setText:[NSString stringWithFormat:@"%.2f", dy]];
	[self.vyf2 setText:[NSString stringWithFormat:@"%.2f", vyf2]];
	[self.vyf setText:[NSString stringWithFormat:@"%.2f", vyf]];
}

- (void)createPhysicsWorld
{
	CGSize screenSize = self.view.bounds.size;
	
	// Define the gravity vector.
	b2Vec2 gravity;
	gravity.Set(0.0f, -9.81f);
	
	// Construct a world object, which will hold and simulate the rigid bodies.
	self.world = new b2World(gravity);
	
	self.world->SetContinuousPhysics(true);
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = self.world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;
	
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox, 0);
	
	// top
	groundBox.Set(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox, 0);
	
	// left
	groundBox.Set(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox, 0);
	
	// right
	groundBox.Set(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox, 0);
}

- (void)addPhysicalBodyForView:(UIView *)physicalView
{
	// Define the dynamic body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	
	// Body will never sleep after period of no acceleration
	bodyDef.allowSleep = FALSE;
	
	CGPoint p = physicalView.center;
	CGPoint boxDimensions = CGPointMake(physicalView.bounds.size.width/PTM_RATIO/2.0,physicalView.bounds.size.height/PTM_RATIO/2.0);
	
	bodyDef.position.Set(p.x/PTM_RATIO, (480.0 - p.y)/PTM_RATIO);
	bodyDef.userData = (__bridge void*)physicalView;
	
	// Tell the physics world to create the body
	b2Body *body = self.world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	
	dynamicBox.SetAsBox(boxDimensions.x, boxDimensions.y);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	fixtureDef.restitution = 0.5f; // 0 is a lead ball, 1 is a super bouncy ball
	body->CreateFixture(&fixtureDef);
	
	// a dynamic body reacts to forces right away
	body->SetType(b2_dynamicBody);
	
	// we abuse the tag property as pointer to the physical body
	physicalView.tag = (int)body;
	
	[self updateKinematicsForBodyView:physicalView];
}

- (void)tick:(NSTimer *)timer
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 10;
	int32 positionIterations = 10;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	self.world->Step(1.0f/60.0f, velocityIterations, positionIterations);
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = self.world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL)
		{
			UIView *oneView = (__bridge UIView *)b->GetUserData();
			
			// y Position subtracted because of flipped coordinate system
			CGPoint newCenter = CGPointMake(b->GetPosition().x * PTM_RATIO,
											self.view.bounds.size.height - b->GetPosition().y * PTM_RATIO);
			oneView.center = newCenter;
			
			CGAffineTransform transform = CGAffineTransformMakeRotation(- b->GetAngle());
			
			oneView.transform = transform;
			
			b2Vec2 linearVelocity = b->GetLinearVelocity();
			[self.verticalVelocityLabel setText:[NSString stringWithFormat:@"%.2f", linearVelocity.y]];
			
			maxVerticalVelocity = linearVelocity.y <= maxVerticalVelocity ? linearVelocity.y : maxVerticalVelocity;
			[self.maxVerticalVelocityLabel setText:[NSString stringWithFormat:@"%.2f", maxVerticalVelocity]];
		}
	}
}


#pragma mark -
#pragma mark ViewController IBActions

- (IBAction)resetButtonPressed:(id)sender
{
	// using the tag property to achieve a pointer to the associated body
	b2Body *b = (b2Body*)self.tennisBall.tag;
	
	float x = 160.0f / PTM_RATIO;
	float y = 480.0f / PTM_RATIO;
	
	b->SetTransform(b2Vec2(x, y),b->GetAngle());
	
	maxVerticalVelocity = 0.0;
	
	[self performSelector:@selector(updateKinematicsForBodyView:) withObject:self.tennisBall afterDelay:(1.0/60.0)];
}


#pragma mark -
#pragma mark UIAccelerometerDelegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	b2Vec2 gravity;
	gravity.Set( acceleration.x * 9.81,  acceleration.y * 9.81 );
	
	self.world->SetGravity(gravity);
}

@end
