#include "whisperworker.h"


whisperworker::whisperworker(QObject *parent)
    : QObject{parent}
{}

void whisperworker::processAudio(const QString &modelPath, const QVector<float> &audioData)
{

    if (audioData.isEmpty()) {
        emit errorOccurred("Audio buffer data is empty.");
        return;
    }

    emit statusMessage("Loading GGML model context...");

    // Initialize whisper context
    struct whisper_context_params cparams = whisper_context_default_params();
    // struct whisper_context * ctx = whisper_init_from_file_with_params(modelPath.tosomeStdString().c_str(), cparams);
    std::string modelPathStd = modelPath.toStdString();
    m_ctx  = whisper_init_from_file_with_params(modelPathStd.c_str(), cparams);
    // struct whisper_context * ctx = whisper_init_from_file_with_params(modelPath.toStdString().c_str(), cparams);

    if (!m_ctx) {
        emit errorOccurred("Failed to initialize whisper model context.");
        return;
    }

    emit statusMessage("Processing audio inference...");

    // Configure standard parameters (Greedy sampling strategy)
    struct whisper_full_params wparams = whisper_full_default_params(WHISPER_SAMPLING_GREEDY);
    wparams.print_progress   = false;
    wparams.print_special    = false;
    wparams.print_realtime   = false;
    wparams.print_timestamps = false;
    wparams.language         = "en"; // Force English, or use "auto"

    // Run the main transcription model
    if (whisper_full(m_ctx, wparams, audioData.data(), audioData.size()) != 0) {
        emit errorOccurred("Failed to process the audio file matrix.");
        whisper_free(m_ctx);
        return;
    }

    // Accumulate output textual segments
    // QString resultText;
    // const int n_segments = whisper_full_n_segments(m_ctx);
    // for (int i = 0; i < n_segments; ++i) {
    //     const char * text = whisper_full_get_segment_text(m_ctx, i);
    //     resultText.append(QString::fromUtf8(text) + " ");
    // }

    QStringList segments;
     const int n_segments = whisper_full_n_segments(m_ctx);
    for (int i = 0; i < n_segments; ++i) {
        segments << QString::fromUtf8(
            whisper_full_get_segment_text(m_ctx, i)
            );
    }

    QString resultText = segments.join(' ');

    // Clean up context allocated memory
    whisper_free(m_ctx);

    emit transcriptionFinished(resultText.trimmed());
}



// implementation exmle

// // Setup Safe Multi-threaded Operations Architecture
// QThread *workerThread = new QThread();
// WhisperWorker *worker = new WhisperWorker();
// worker->moveToThread(workerThread);

// // Wire Core Engine Communications
// QObject::connect(startBtn, &QPushButton::clicked, [=]() {
//     startBtn->setEnabled(false);
//     // Replace this path with your downloaded local custom whisper model file path
//     QString modelPath = "./ggml-base.en.bin";
//     QVector<float> audioBuffer = generateMockAudio();

//     // Invoke execution safely on the dedicated worker thread line
//     QMetaObject::invokeMethod(worker, "processAudio", Qt::QueuedConnection,
//                               Q_ARG(QString, modelPath),
//                               Q_ARG(QVector<float>, audioBuffer));
// });

// QObject::connect(worker, &WhisperWorker::statusMessage, statusLabel, &QLabel::setText);

// QObject::connect(worker, &WhisperWorker::transcriptionFinished, [=](const QString &text) {
//     textEdit->setText(text);
//     statusLabel->setText("Status: Finished!");
//     startBtn->setEnabled(true);
// });

// QObject::connect(worker, &WhisperWorker::errorOccurred, [=](const QString &error) {
//     QMessageBox::critical(&window, "Inference Failure", error);
//     statusLabel->setText("Status: Error occurred");
//     startBtn->setEnabled(true);
// });

// // Handle Thread Cleanup safely on close
// QObject::connect(&app, &QApplication::aboutToQuit, [=]() {
//     workerThread->quit();
//     workerThread->wait();
//     delete worker;
//     delete workerThread;
// });
