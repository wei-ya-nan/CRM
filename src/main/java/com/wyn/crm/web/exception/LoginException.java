package com.wyn.crm.web.exception;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/16
 */
public class LoginException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public LoginException() {
        super();
    }

    public LoginException(String message) {
        super(message);
    }

    public LoginException(String message, Throwable cause) {
        super(message, cause);
    }

    public LoginException(Throwable cause) {
        super(cause);
    }

    protected LoginException(String message, Throwable cause, boolean enableSuppression,
                             boolean writableStackTrace) {

    }
}
