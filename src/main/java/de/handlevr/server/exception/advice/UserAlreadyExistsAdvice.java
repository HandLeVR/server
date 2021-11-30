package de.handlevr.server.exception.advice;

import de.handlevr.server.exception.UserAlreadyExistsException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

/*
 * Tells the rest controller which error code and message should be returned if a UserAlreadyExistsException is thrown.
 */
@ControllerAdvice
public class UserAlreadyExistsAdvice {

    @ResponseBody
    @ExceptionHandler(UserAlreadyExistsException.class)
    @ResponseStatus(HttpStatus.CONFLICT)
    String userAlreadyExisitsHandler(UserAlreadyExistsException ex) {
        return ex.getMessage();
    }
}
