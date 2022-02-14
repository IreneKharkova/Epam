

trigger UpdateTaskForAccountTrigger on Account (before update) {
    Boolean flag = true;
    if(Trigger.isBefore) {
        if(Trigger.isUpdate) {
            List<Task> tasks = new List<Task>();
            List<Account> accounts = [
                    SELECT Id,
                    (
                            SELECT OwnerId
                            FROM Tasks
                    )
                    FROM Account
                    WHERE Id IN :Trigger.new
            ];
            User user = [
                    SELECT Id
                    FROM User
                    WHERE User.IsActive = TRUE
                    LIMIT 1
            ];
            for (Account account : accounts) {
                if (flag = true && account.Tasks.size() > 3) {
                    flag = false;
                    for (Task task : account.Tasks) {
                        task.OwnerId = user.Id;
                        tasks.add(task);
                    }
                }
            }
        }
    }

}