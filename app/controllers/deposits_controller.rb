# frozen_string_literal: true

class DepositsController < ApplicationController
  before_action :set_deposit, only: %i[show edit update destroy]

  # GET /deposits or /deposits.json
  def index
    @deposits = Deposit.all
    @sum = 0
  end

  # GET /deposits/1 or /deposits/1.json
  def show; end

  # GET /deposits/new
  def new
    @deposit = Deposit.new
  end

  # GET /deposits/1/edit
  def edit; end

  # POST /deposits or /deposits.json
  def create
    @deposit = Deposit.new(deposit_params)

    respond_to do |format|
      if @deposit.save
        @deposit.officer.update(amount_owed: @deposit.officer.amount_owed - @deposit.amount)
        format.html { redirect_to @deposit, notice: 'Deposit was successfully created.' }
        format.json { render :show, status: :created, location: @deposit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deposits/1 or /deposits/1.json
  def update
    respond_to do |format|
      @old_amount = @deposit.amount
      @old_officer_uin = @deposit.officer_uin
      @old_officer = @deposit.officer
      if @deposit.update(deposit_params)
        if @old_officer_uin == @deposit.officer_uin
          @deposit.officer.update(amount_owed: @deposit.officer.amount_owed - @deposit.amount + @old_amount)
        else
          @deposit.officer.update(amount_owed: @deposit.officer.amount_owed - @deposit.amount)
          @old_officer.update(amount_owed: @old_officer.amount_owed + @old_amount)
        end
        format.html { redirect_to @deposit, notice: 'Deposit was successfully updated.' }
        format.json { render :show, status: :ok, location: @deposit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deposits/1 or /deposits/1.json
  def destroy
    @deposit.destroy
    respond_to do |format|
      format.html { redirect_to deposits_url, notice: 'Deposit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_deposit
    @deposit = Deposit.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def deposit_params
    params.require(:deposit).permit(:deposit_id, :officer_uin, :amount, :notes, :date)
  end
end
