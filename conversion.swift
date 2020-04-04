func queueBufferToAudioBuffer(_ buffer:  AudioQueueBufferRef) -> AVAudioPCMBuffer? {
        guard let audioFormat = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: format.mSampleRate,
            channels: format.mChannelsPerFrame,
            interleaved: true)
        else { return nil }
        
        let frameLength = buffer.pointee.mAudioDataBytesCapacity / audioFormat.streamDescription.pointee.mBytesPerFrame
        
        guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: frameLength) else { return nil }
        
        audioBuffer.frameLength = frameLength
        let dstLeft = audioBuffer.floatChannelData![0]
        
        let src = buffer.pointee.mAudioData.bindMemory(to: Float.self, capacity: Int(frameLength))
        dstLeft.initialize(from: src, count: Int(frameLength))
        
        return audioBuffer
    }
