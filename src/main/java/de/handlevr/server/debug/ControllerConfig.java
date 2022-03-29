package de.handlevr.server.debug;

import org.springframework.http.HttpStatus;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.server.ResponseStatusException;

/**
 * Allows printing errors caused by wrong requests.
 */
@ControllerAdvice
public class ControllerConfig {

    /*
    @ExceptionHandler
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public void handle(HttpMessageNotReadableException e) {
        System.err.println("Returning HTTP 400 Bad Request");
        e.printStackTrace();
        throw e;
    }

    @ExceptionHandler
    @ResponseStatus(HttpStatus.CONFLICT)
    public void handle(ResponseStatusException e) {
        System.err.println("Returning HTTP 409 Conflict");
        e.printStackTrace();
        throw e;
    }*/
}
