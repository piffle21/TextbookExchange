class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @conversations = current_user.conversations
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @receiver = User.find(params[:receiver_id])
    @message = current_user.sent_messages.build(:receiver_id => @receiver.id)
    @conversation = current_user.conversation(@receiver.id)
    book = params[:book_id] ? Book.find(params[:book_id]) : nil
    @preview = book ? "I want to buy your #{book.course} book!" : ""
    notifications = current_user.notifications_with(@receiver.id)
    notifications.each {|n| n.destroy }
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = current_user.sent_messages.build(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to new_message_path(:receiver_id => @message.receiver_id) }
        format.json { render action: 'show', status: :created, location: @message }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:sender_id, :receiver_id, :text, :book_id)
    end
end
