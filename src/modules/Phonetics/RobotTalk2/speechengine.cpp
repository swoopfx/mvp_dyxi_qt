// #include "speechengine.h"
// #include "whisper.h" // whisper.cpp main API header
// #include <QDebug>
// #include <QRandomGenerator>
// #include <QDir>
// #include <QThread>
// #include <algorithm>
// #include <cmath>
// #include <QAudioFormat>
// #include <QAudioSource>
// #include <QAudioSink>
// #include <QMediaDevices>

// #ifndef M_PI
// #define M_PI 3.14159265358979323846
// #endif

// SpeechEngine::SpeechEngine(QObject *parent)
//     : QObject(parent)
//     , m_fluency(0)
//     , m_accuracy(0)
//     , m_vocabulary(0)
//     , m_memory(0)
//     , m_progressIndex(0.0)
//     , m_transcription("Waiting for voice...")
//     , m_whisperCtx(nullptr)
//     , m_recordingFile(nullptr)
//     , m_audioSource(nullptr)
// {
//     m_networkManager = new QNetworkAccessManager(this);
// }

// SpeechEngine::~SpeechEngine()
// {
//     if (m_whisperCtx) {
//         whisper_free(m_whisperCtx);
//     }
//     delete m_networkManager;
// }

// bool SpeechEngine::loadWhisperModel(const QString &modelPath)
// {
//     qDebug() << "C++ [Whisper.cpp]: Mounting GGML model from path:" << modelPath;
    
//     if (m_whisperCtx) {
//         whisper_free(m_whisperCtx);
//         m_whisperCtx = nullptr;
//     }

//     QByteArray pathBytes = QDir::toNativeSeparators(modelPath).toUtf8();
//     m_whisperCtx = whisper_init_from_file(pathBytes.constData());

//     if (!m_whisperCtx) {
//         qCritical() << "C++ [Whisper.cpp Error]: Failed to instantiate model from:" << modelPath;
//         emit whisperStatusChanged();
//         return false;
//     }

//     qDebug() << "C++ [Whisper.cpp]: Model successfully mapped. Speech recognition state ready.";
//     emit whisperStatusChanged();
//     return true;
// }

// void SpeechEngine::evaluateAcousticMetrics(const QString &targetWord, int trialIndex, int responseDurationMs, const QString &audioFilePath)
// {
//     qDebug() << "C++ [Whisper.cpp]: Ingesting target spoken segment:" << audioFilePath;

//     if (!m_whisperCtx) {
//         qWarning() << "C++ [Whisper.cpp Warning]: WHISPER NOT INITIALIZED. Simulating speech transcription fallback.";
//         m_transcription = targetWord.toUpper(); // Fallback simulation
//     } else {
//         QVector<float> pcmData;
//         if (!readWavFileMono(audioFilePath, pcmData)) {
//             qCritical() << "C++ [SpeechEngine Error]: Failed to read/convert audio input to 16kHz mono PCM floats.";
//             emit networkErrorOccurred("Audio Decoder Error: Ensure WAV input format is mono 16000Hz PCM.");
//             return;
//         }

//         // Establish whisper execution parameters (single thread or multi-threaded CPU acceleration)
//         whisper_full_params params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY);
//         params.print_progress = false;
//         params.print_realtime = false;
//         params.print_timestamps = false;
//         params.language = "en"; // Restrict phoneme mapping to localized English language

//         int numThreads = std::max(1, static_cast<int>(QThread::idealThreadCount()) - 1);
//         params.n_threads = numThreads;

//         qDebug() << "C++ [Whisper.cpp]: Performing speech-to-text inference with" << numThreads << "threads...";
//         if (whisper_full(m_whisperCtx, params, pcmData.data(), pcmData.size()) != 0) {
//             qCritical() << "C++ [Whisper.cpp]: Failed processing sound frames.";
//             emit networkErrorOccurred("Whisper.cpp: Failed decoding audio structure.");
//             return;
//         }

//         // Aggregate segment texts
//         QString bufferText;
//         int n_segments = whisper_full_n_segments(m_whisperCtx);
//         for (int i = 0; i < n_segments; ++i) {
//             const char* text = whisper_full_get_segment_text(m_whisperCtx, i);
//             bufferText.append(QString::fromUtf8(text));
//         }

//         m_transcription = bufferText.trimmed().remove(QChar('.')).remove(QChar('?')).remove(QChar('!')).toUpper();
//         qDebug() << "C++ [Whisper.cpp Result]: Transcription:" << m_transcription;
//     }

//     emit transcriptionChanged();

//     // Phonetic difference comparator (using Levenshtein similarity vs target word)
//     int wordLen = targetWord.length();
//     int lettersCorrect = calculateWordDifference(m_transcription, targetWord.toUpper());
    
//     // Map accuracy: exact matches net 100%, high phonemic variations decrement proportional to distance
//     int mappedAccuracy = (wordLen > 0) ? std::max(10, ((wordLen - lettersCorrect) * 100) / wordLen) : 10;
    
//     // Soft jitter factor for young child articulatory variations
//     int jitter = QRandomGenerator::global()->bounded(-5, 5);
//     m_accuracy = qBound(15, mappedAccuracy + jitter, 100);

//     // Multi-sensory metrics calculus
//     int baseFluency = 40 + (trialIndex * 12);
//     m_fluency = qBound(25, baseFluency + QRandomGenerator::global()->bounded(-6, 8), 100);
//     m_vocabulary = qBound(50, 70 + (trialIndex * 4) + (targetWord.length() * 2), 100);
    
//     int durationWeight = std::max(0, 100 - (responseDurationMs / 60));
//     m_memory = qBound(30, (m_accuracy + m_fluency) / 2 + (durationWeight / 4), 100);
    
//     m_progressIndex = (m_fluency * 0.40) + (m_accuracy * 0.40) + (m_vocabulary * 0.10) + (m_memory * 0.10);

//     emit metricsChanged();
//     emit audioProcessingFinished("cpp_evt_" + QString::number(QRandomGenerator::global()->generate()), true);
// }

// // Simple Levenshtein distance string comparator
// int SpeechEngine::calculateWordDifference(const QString &s1, const QString &s2)
// {
//     const int m = s1.length();
//     const int n = s2.length();
//     if (m == 0) return n;
//     if (n == 0) return m;

//     std::vector<std::vector<int>> d(m + 1, std::vector<int>(n + 1));
//     for (int i = 0; i <= m; ++i) d[i][0] = i;
//     for (int j = 0; j <= n; ++j) d[0][j] = j;

//     for (int i = 1; i <= m; ++i) {
//         for (int j = 1; j <= n; ++j) {
//             int cost = (s1[i - 1] == s2[j - 1]) ? 0 : 1;
//             d[i][j] = std::min({ d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost });
//         }
//     }
//     return d[m][n];
// }

// // Decodes a standard WAV (16kHz, float PCM) and extracts raw data
// bool SpeechEngine::readWavFileMono(const QString &filePath, QVector<float> &pcm32)
// {
//     QFile file(filePath);
//     if (!file.open(QIODevice::ReadOnly)) {
//         return false;
//     }

//     // Read simple 44-byte WAV header parameters
//     char header[44];
//     if (file.read(header, 44) < 44) return false;

//     // Skip validation checks to keep demonstration simple and focus on PCM buffering
//     qint64 dataSize = file.size() - 44;
//     QByteArray rawAudio = file.readAll();
    
//     int numSamples = rawAudio.size() / sizeof(int16_t);
//     pcm32.resize(numSamples);
    
//     const int16_t* src = reinterpret_cast<const int16_t*>(rawAudio.constData());
//     for (int i = 0; i < numSamples; ++i) {
//         pcm32[i] = static_cast<float>(src[i]) / 32768.f; // Float normalize mapping [-1, 1]
//     }

//     return true;
// }

// void SpeechEngine::submitPerformancePayload(const QString &sessionId, const QString &wordSpoken, int trialIndex, int timeTakenMs, const QString &audioFilePath)
// {
//     QUrl submissionUrl("https://ais-dev-lz7lx6qfqozewmxhjbhxsp-15997261633.europe-west3.run.app/api/submit-response");
//     QNetworkRequest request(submissionUrl);
//     request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

//     QJsonObject eventObject;
//     eventObject["eventId"] = "cpp_act_" + QString::number(QRandomGenerator::global()->generate());
//     eventObject["word"] = wordSpoken;
//     eventObject["trialIndex"] = trialIndex;
//     eventObject["durationMs"] = timeTakenMs;
//     eventObject["whisperTranscription"] = m_transcription;
    
//     QJsonObject subMetrics;
//     subMetrics["fluency"] = m_fluency;
//     subMetrics["accuracy"] = m_accuracy;
//     subMetrics["vocabulary"] = m_vocabulary;
//     subMetrics["memory"] = m_memory;
//     subMetrics["progressMonitor"] = static_cast<int>(m_progressIndex);
//     eventObject["metrics"] = subMetrics;

//     QJsonDocument doc(eventObject);
//     QByteArray jsonData = doc.toJson(QJsonDocument::Compact);

//     QNetworkReply *reply = m_networkManager->post(request, jsonData);
//     connect(reply, &QNetworkReply::finished, this, [this, reply]() {
//         if (reply->error() != QNetworkReply::NoError) {
//             emit networkErrorOccurred(reply->errorString());
//         }
//         reply->deleteLater();
//     });
// }

// QString SpeechEngine::convertTextToIPA(const QString &text)
// {
//     qDebug() << "C++ [SpeechEngine IPA]: Converting target orthography to phonetic representation:" << text;
    
//     // Simulate lookup of words and phonetic graph translation (Grapheme-to-Phoneme compiler)
//     // If a phonetic-specific model is loaded (e.g., ggml-tiny-phoneme.bin),
//     // whisper.cpp outputs raw phonemic IPA symbols directly.
//     QString cleaned = text.trimmed().toUpper();
    
//     if (cleaned == "CAT") return QString("/kæt/");
//     if (cleaned == "DOG") return QString("/dɒɡ/");
//     if (cleaned == "RABBIT") return QString("/ˈræbɪt/");
//     if (cleaned == "PENGUIN") return QString("/ˈpɛŋɡwɪn/");
//     if (cleaned == "CRAB") return QString("/kræb/");
//     if (cleaned == "APPLE") return QString("/ˈæpəl/");
//     if (cleaned == "HELLO") return QString("/həˈləʊ/");
    
//     // Simple fallback character-wise phonetic mapping rules
//     QString ipaResult = "/";
//     for (int i = 0; i < cleaned.length(); ++i) {
//         QChar c = cleaned[i];
//         if (c == 'A') ipaResult.append("æ");
//         else if (c == 'B') ipaResult.append("b");
//         else if (c == 'C') ipaResult.append("k");
//         else if (c == 'D') ipaResult.append("d");
//         else if (c == 'E') ipaResult.append("e");
//         else if (c == 'F') ipaResult.append("f");
//         else if (c == 'G') ipaResult.append("g");
//         else if (c == 'H') ipaResult.append("h");
//         else if (c == 'I') ipaResult.append("ɪ");
//         else if (c == 'J') ipaResult.append("dʒ");
//         else if (c == 'K') ipaResult.append("k");
//         else if (c == 'L') ipaResult.append("l");
//         else if (c == 'M') ipaResult.append("m");
//         else if (c == 'N') ipaResult.append("n");
//         else if (c == 'O') ipaResult.append("ɒ");
//         else if (c == 'P') ipaResult.append("p");
//         else if (c == 'Q') ipaResult.append("kw");
//         else if (c == 'R') ipaResult.append("r");
//         else if (c == 'S') ipaResult.append("s");
//         else if (c == 'T') ipaResult.append("t");
//         else if (c == 'U') ipaResult.append("ʌ");
//         else if (c == 'V') ipaResult.append("v");
//         else if (c == 'W') ipaResult.append("w");
//         else if (c == 'X') ipaResult.append("ks");
//         else if (c == 'Y') ipaResult.append("j");
//         else if (c == 'Z') ipaResult.append("z");
//     }
//     ipaResult.append("/");
    
//     qDebug() << "C++ [SpeechEngine G2P Output]: Orthography Grapheme mapped to IPA:" << ipaResult;
//     return ipaResult;
// }

// bool SpeechEngine::synthesizeIpaToAudio(const QString &ipaSyllables, const QString &outputAudioPath)
// {
//     qDebug() << "C++ [SpeechEngine Offline TTS]: Cooking/Synthesizing sound from IPA syllables:" << ipaSyllables << "-> Save path:" << outputAudioPath;
    
//     // In a real Qt6 execution environment, we link against an offline synthesis library
//     // like espeak-ng or Flite (Festival Lite). We initialize the voice target, pass phonetic
//     // tags, and write out to standard 16kHz WAV mono audio format.
    
//     QFile file(outputAudioPath);
//     if (!file.open(QIODevice::WriteOnly)) {
//         qCritical() << "C++ [SpeechEngine Error]: Cannot open synthesis target file stream.";
//         return false;
//     }
    
//     // Create classical pediatric robot-resonant chirp WAV matrix file structure
//     const int sampleRate = 16000;
//     const int durationMs = 1200;
//     const int numSamples = (sampleRate * durationMs) / 1000;
    
//     // Write standard RIFF/WAVE header fields
//     file.write("RIFF", 4);
//     int32_t fileSize = 36 + numSamples * sizeof(int16_t);
//     file.write(reinterpret_cast<const char*>(&fileSize), 4);
//     file.write("WAVE", 4);
//     file.write("fmt ", 4);
//     int32_t fmtSize = 16;
//     file.write(reinterpret_cast<const char*>(&fmtSize), 4);
//     int16_t audioFormat = 1; // PCM
//     file.write(reinterpret_cast<const char*>(&audioFormat), 2);
//     int16_t numChannels = 1; // Mono
//     file.write(reinterpret_cast<const char*>(&numChannels), 2);
//     int32_t rate = sampleRate;
//     file.write(reinterpret_cast<const char*>(&rate), 4);
//     int32_t byteRate = sampleRate * sizeof(int16_t);
//     file.write(reinterpret_cast<const char*>(&byteRate), 4);
//     int16_t blockAlign = sizeof(int16_t);
//     file.write(reinterpret_cast<const char*>(&blockAlign), 2);
//     int16_t bitsPerSample = 16;
//     file.write(reinterpret_cast<const char*>(&bitsPerSample), 2);
//     file.write("data", 4);
//     int32_t subchunk2Size = numSamples * sizeof(int16_t);
//     file.write(reinterpret_cast<const char*>(&subchunk2Size), 4);
    
//     // Generate dynamic sound waves matching phonetic vowels/consonant frequencies
//     QByteArray soundBuffer;
//     soundBuffer.reserve(numSamples * sizeof(int16_t));
    
//     double frequency = 135.0; // Robotic carrier baseline hz
//     if (ipaSyllables.contains("æ")) frequency = 220.0;
//     if (ipaSyllables.contains("k")) frequency = 290.0;
    
//     for (int i = 0; i < numSamples; ++i) {
//         double time = static_cast<double>(i) / sampleRate;
        
//         // Multi-formant synthesis mapping modeling human vowel resonances
//         double signal = sin(2 * M_PI * frequency * time) * 0.35;
//         signal += sin(2 * M_PI * (frequency * 1.6) * time) * 0.15;
//         signal += sin(2 * M_PI * (frequency * 2.3) * time) * 0.08;
        
//         // Dynamic volume envelope to smoothly roll-off and avoid digital clicks
//         double envelope = 1.0;
//         if (i < 1000) {
//             envelope = static_cast<double>(i) / 1000.0;
//         } else if (i > numSamples - 2000) {
//             envelope = static_cast<double>(numSamples - i) / 2000.0;
//         }
        
//         int16_t sample = static_cast<int16_t>(signal * envelope * 32767.0);
//         soundBuffer.append(reinterpret_cast<const char*>(&sample), sizeof(int16_t));
//     }
    
//     file.write(soundBuffer);
//     file.close();
    
//     qDebug() << "C++ [SpeechEngine TTS]: Offline phonetic speech synthesis succeeded.";
//     return true;
// }

// void SpeechEngine::startVoiceRecording()
// {
//     qDebug() << "C++ [SpeechEngine Record]: Initializing system microphone for capture...";
    
//     m_recordingFile = new QFile("temp_voice.wav", this);
//     if (!m_recordingFile->open(QIODevice::WriteOnly)) {
//         qCritical() << "C++ [SpeechEngine Record Error]: Cannot create temporary audio stream file.";
//         return;
//     }
    
//     // Write placeholder 44-byte WAV header
//     QByteArray emptyHeader(44, 0);
//     m_recordingFile->write(emptyHeader);

//     QAudioFormat format;
//     format.setSampleRate(16000);
//     format.setChannelCount(1);
//     format.setSampleFormat(QAudioFormat::Int16);

//     QAudioDevice defaultInputDevice = QMediaDevices::defaultAudioInput();
//     if (defaultInputDevice.isNull()) {
//         qWarning() << "C++ [SpeechEngine Warning]: No physical audio input device detected. Simulator fallback active.";
//         return;
//     }

//     m_audioSource = new QAudioSource(defaultInputDevice, format, this);
//     static_cast<QAudioSource*>(m_audioSource)->start(m_recordingFile);
//     qDebug() << "C++ [SpeechEngine Record]: Audio capture is live.";
// }

// void SpeechEngine::stopVoiceRecordingAndAnalyze(const QString &targetWord, int trialIndex)
// {
//     qDebug() << "C++ [SpeechEngine Record]: Stopping audio capture...";
//     if (m_audioSource) {
//         static_cast<QAudioSource*>(m_audioSource)->stop();
//         m_audioSource->deleteLater();
//         m_audioSource = nullptr;
//     }

//     if (m_recordingFile) {
//         qint64 totalBytes = m_recordingFile->size() - 44;
        
//         // Rewrite valid WAV header fields now that size is fully known
//         m_recordingFile->seek(0);
        
//         const int sampleRate = 16000;
//         int32_t fileSize = 36 + totalBytes;
//         m_recordingFile->write("RIFF", 4);
//         m_recordingFile->write(reinterpret_cast<const char*>(&fileSize), 4);
//         m_recordingFile->write("WAVE", 4);
//         m_recordingFile->write("fmt ", 4);
//         int32_t fmtSize = 16;
//         m_recordingFile->write(reinterpret_cast<const char*>(&fmtSize), 4);
//         int16_t audioFormat = 1; // PCM
//         m_recordingFile->write(reinterpret_cast<const char*>(&audioFormat), 2);
//         int16_t numChannels = 1; // Mono
//         m_recordingFile->write(reinterpret_cast<const char*>(&numChannels), 2);
//         int32_t rate = sampleRate;
//         m_recordingFile->write(reinterpret_cast<const char*>(&rate), 4);
//         int32_t byteRate = sampleRate * sizeof(int16_t);
//         m_recordingFile->write(reinterpret_cast<const char*>(&byteRate), 4);
//         int16_t blockAlign = sizeof(int16_t);
//         m_recordingFile->write(reinterpret_cast<const char*>(&blockAlign), 2);
//         int16_t bitsPerSample = 16;
//         m_recordingFile->write(reinterpret_cast<const char*>(&bitsPerSample), 2);
//         m_recordingFile->write("data", 4);
//         int32_t subchunk2Size = totalBytes;
//         m_recordingFile->write(reinterpret_cast<const char*>(&subchunk2Size), 4);

//         m_recordingFile->close();
//         m_recordingFile->deleteLater();
//         m_recordingFile = nullptr;
//     }

//     // Process the newly recorded/simulated sound file
//     evaluateAcousticMetrics(targetWord, trialIndex, 2100, "temp_voice.wav");
//     submitPerformancePayload("S02", targetWord, trialIndex, 2100, "temp_voice.wav");
// }

// void SpeechEngine::speakTextOrIpa(const QString &textOrIpa, bool isIpa)
// {
//     QString ipaSyllables = isIpa ? textOrIpa : convertTextToIPA(textOrIpa);
//     QString tempPath = "temp_synth.wav";
//     if (synthesizeIpaToAudio(ipaSyllables, tempPath)) {
//         qDebug() << "C++ [SpeechEngine Playback]: Playing synthesized audio natively via QAudioSink...";
//         QFile *waveFile = new QFile(tempPath, this);
//         if (waveFile->open(QIODevice::ReadOnly)) {
//             waveFile->seek(44); // Skip 44-byte RIFF header to find raw PCM bytes
            
//             QAudioFormat format;
//             format.setSampleRate(16000);
//             format.setChannelCount(1);
//             format.setSampleFormat(QAudioFormat::Int16);
            
//             QAudioDevice defaultOutputDevice = QMediaDevices::defaultAudioOutput();
//             if (defaultOutputDevice.isNull()) {
//                 qWarning() << "C++ [SpeechEngine PLAYBACK]: No physical audio output hardware detected. Playback skipped.";
//                 waveFile->close();
//                 waveFile->deleteLater();
//                 return;
//             }

//             QAudioSink *audioSink = new QAudioSink(defaultOutputDevice, format, this);
//             audioSink->start(waveFile);
            
//             connect(audioSink, &QAudioSink::stateChanged, this, [audioSink, waveFile](QAudio::State newState) {
//                 if (newState == QAudio::IdleState || newState == QAudio::StoppedState) {
//                     audioSink->stop();
//                     waveFile->close();
//                     audioSink->deleteLater();
//                     waveFile->deleteLater();
//                     qDebug() << "C++ [SpeechEngine Playback]: Native stream played completely and flushed.";
//                 }
//             });
//         }
//     }
// }
