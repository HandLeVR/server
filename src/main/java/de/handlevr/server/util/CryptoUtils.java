package de.handlevr.server.util;

import de.handlevr.server.statics.Constants;
import de.handlevr.server.exception.CryptoException;

import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;

/**
 * A utility class that encrypts or decrypts a file.
 * Source: https://www.codejava.net/coding/file-encryption-and-decryption-simple-example
 *
 */
public class CryptoUtils {
    private static final String ALGORITHM = "AES";
    private static final String TRANSFORMATION = "AES";

    public static byte[] encrypt(byte[] inputBytes) throws CryptoException {
        return doCrypto(Cipher.ENCRYPT_MODE, inputBytes);
    }

    public static byte[] decrypt( byte[] inputBytes) throws CryptoException {
        return doCrypto(Cipher.DECRYPT_MODE, inputBytes);
    }

    private static byte[] doCrypto(int cipherMode, byte[] inputBytes) throws CryptoException {
        try {
            Key secretKey = new SecretKeySpec(Constants.CRYPTO_KEY.getBytes(), ALGORITHM);
            Cipher cipher = Cipher.getInstance(TRANSFORMATION);
            cipher.init(cipherMode, secretKey);
            return cipher.doFinal(inputBytes);

        } catch (NoSuchPaddingException | NoSuchAlgorithmException
                | InvalidKeyException | BadPaddingException
                | IllegalBlockSizeException ex) {
            throw new CryptoException("Error encrypting/decrypting file", ex);
        }
    }
}