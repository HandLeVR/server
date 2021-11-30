package de.handlevr.server.exception;

public class UserAlreadyExistsException extends RuntimeException {

    public UserAlreadyExistsException(String name) {
        super("User with the name " + name + " already exists.");
    }

    public UserAlreadyExistsException(long id) {
        super("User with the id " + id + " already exists.");
    }
}
