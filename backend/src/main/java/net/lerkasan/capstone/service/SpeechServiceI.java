package net.lerkasan.capstone.service;


import software.amazon.awssdk.services.polly.model.OutputFormat;

import java.io.InputStream;

public interface SpeechServiceI {
    InputStream synthesizeSpeech(String text, String voiceId, OutputFormat format);
}
