//
//  NNPMasterViewController.m
//  ToDo
//
//  Created by damian on 14/04/2012.
//

#import "NNPMasterViewController.h"

@interface NNPMasterViewController()
-(void) deleteFromTableAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation NNPMasterViewController

-(void) deleteFromTableAtIndexPath:(NSIndexPath *)indexPath {
    [appDelegate.toDos removeObjectAtIndex:[indexPath row]];    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    appDelegate = (NNPAppDelegate *)[[UIApplication sharedApplication] delegate];    
    _lowImg = [UIImage imageNamed:@"low"];
    _mediumImg = [UIImage imageNamed:@"medium"];
    _highImg = [UIImage imageNamed:@"high"];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [appDelegate.toDos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";    
    ToDo *task;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    task = (ToDo *)[appDelegate.toDos objectAtIndex:[indexPath row]];
    cell.textLabel.text = task.toDo;
    cell.detailTextLabel.text = task.toDoDescription;
    switch (task.toDoPriority) {
        case 0:
            cell.imageView.image = _lowImg;
            break;
        case 1:
            cell.imageView.image = _mediumImg;
            break;
        case 2:
            cell.imageView.image = _highImg;
            break;
        default:
            break;
    }    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ToDoDetail"])
	{
        NNPDetailViewController *toDoDetailViewController = segue.destinationViewController;        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        ToDo *task = [appDelegate.toDos objectAtIndex:[path row]];
        toDoDetailViewController.detailItem = task;
        toDoDetailViewController.delegate = self;
        toDoDetailViewController.parentCellIndexPath = path;
	}
    
	if ([segue.identifier isEqualToString:@"ToDoAdd"]) {
        NNPDetailViewController *toDoDetailViewController = segue.destinationViewController;        
        toDoDetailViewController.delegate = self;
        toDoDetailViewController.parentCellIndexPath = nil;
    }
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteFromTableAtIndexPath:indexPath];
    }
}

- (void)refreshTableAfter:(int)operation:(id)withObject :(NSIndexPath*)andIndexPath {
    switch (operation) {
        case INSERT:
        {            
            [appDelegate.toDos insertObject:withObject atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionTop animated:YES];

            break;
        }
        case UPDATE:
            [appDelegate.toDos replaceObjectAtIndex:[andIndexPath row] withObject:withObject];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:andIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView scrollToRowAtIndexPath:andIndexPath
                                  atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            break;
        case DELETE:            
            [self deleteFromTableAtIndexPath:andIndexPath];
            
            break;
        default:
            break;
    }
}

@end
