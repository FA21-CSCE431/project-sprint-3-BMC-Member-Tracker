# frozen_string_literal: true

class WithdrawalsController < ApplicationController
  before_action :set_withdrawal, only: %i[show edit update destroy]

  # GET /withdrawals or /withdrawals.json
  def index
    @withdrawals = Withdrawal.all
    @sum = 0
  end

  # GET /withdrawals/1 or /withdrawals/1.json
  def show; end

  # GET /withdrawals/new
  def new
    @withdrawal = Withdrawal.new
  end

  # GET /withdrawals/1/edit
  def edit; end

  # POST /withdrawals or /withdrawals.json
  def create
    @withdrawal = Withdrawal.new(withdrawal_params)

    respond_to do |format|
      if @withdrawal.save
        @withdrawal.officer.update(amount_owed: @withdrawal.amount + @withdrawal.officer.amount_owed)
        format.html { redirect_to @withdrawal, notice: 'Withdrawal was successfully created.' }
        format.json { render :show, status: :created, location: @withdrawal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @withdrawal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /withdrawals/1 or /withdrawals/1.json
  def update
    respond_to do |format|
      @old_amount = @withdrawal.amount
      @old_officer = @withdrawal.officer
      @old_officer_uin = @withdrawal.officer_uin
      if @withdrawal.update(withdrawal_params)
        if @old_officer_uin == @withdrawal.officer_uin
          @withdrawal.officer.update(amount_owed: @withdrawal.officer.amount_owed + @withdrawal.amount - @old_amount)
        else
          @withdrawal.officer.update(amount_owed: @withdrawal.officer.amount_owed + @withdrawal.amount)
          @old_officer.update(amount_owed: @old_officer.amount_owed - @old_amount)
        end
        format.html { redirect_to @withdrawal, notice: 'Withdrawal was successfully updated.' }
        format.json { render :show, status: :ok, location: @withdrawal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @withdrawal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /withdrawals/1 or /withdrawals/1.json
  def destroy
    @withdrawal.destroy
    respond_to do |format|
      format.html { redirect_to withdrawals_url, notice: 'Withdrawal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_withdrawal
    @withdrawal = Withdrawal.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def withdrawal_params
    params.require(:withdrawal).permit(:withdraw_id, :officer_uin, :amount, :title, :description, :date)
  end
end
