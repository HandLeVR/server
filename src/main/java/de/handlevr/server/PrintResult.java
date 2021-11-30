package de.handlevr.server;

// Location in folder temporary, i didn't know where to put it
// this class is meant to be used as an output for getPrintResults in TaskResultController

public class PrintResult {

   public Long userId;
   public Long taskId;
   public String result;

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getTaskId() {
        return taskId;
    }

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }
}