require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '/spec_helper'))

describe Mailman::Receiver::IMAP do

  before do
    @processor = double('Message Processor', :process => true)
    @receiver_options = { :username  => 'user',
                          :password  => 'pass',
                          :server    =>  'example.com',
                          :processor => @processor }
    @receiver = Mailman::Receiver::IMAP.new(@receiver_options)
  end

  describe 'connection' do

    it 'should connect to a IMAP server' do
      @receiver.connect.should be_true
    end

    it 'should disconnect from a IMAP server' do
      @receiver.connect
      @receiver.disconnect.should be_true
    end

  end

  describe 'message reception' do
    before do
      @receiver.connect
    end

    it 'should get messages and process them' do
      @processor.should_receive(:process).twice.with(/test/)
      @receiver.get_messages
    end

    it 'should delete the messages after processing' do
      @receiver.get_messages
      @receiver.connection.search(:all).should be_empty
    end

    it 'should not delete the messages after processing if delete_messages is set to false' do
      @receiver_optons[:delete_messages] = false
      @receiver.get_messages
      @receiver.connection.mails.should_not be_empty
    end
  end

end
