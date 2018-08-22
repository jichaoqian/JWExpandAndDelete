# JWExpandAndDelete
#### 一 这只是一个tableview的展开和删除的小Demo
**其实主要就是一句代码**
[self.tableView beginUpdates];
[self.tableView deleteRowsAtIndexPaths:[self indexPathsForExpandRow:indexPath.row] withRowAnimation:UITableViewRowAnimationTop];
[self.tableView endUpdates];
