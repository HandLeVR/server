package de.handlevr.server.exception.advice;

import de.handlevr.server.exception.InternalServerErrorException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Tells the rest controller which error code and message should be returned if a InternalServerErrorException is thrown.
 */
@ControllerAdvice
public class InternalServerErrorAdvice {

    @ResponseBody
    @ExceptionHandler(InternalServerErrorException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    String internalServerErrorHandler(InternalServerErrorException ex) {
        return ex.getMessage();
    }
}
