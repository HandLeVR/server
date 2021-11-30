package de.handlevr.server.exception;

public class InternalServerErrorException extends RuntimeException {

    public InternalServerErrorException() {
        super("Unexpected server error");
    }
}