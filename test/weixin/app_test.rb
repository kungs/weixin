require 'test_helper'

class Weixin::AppTest < MiniTest::Test

  def test_prepayid_lack_params
    begin
      Weixin::App.prepay_id({}, '123')
      assert false, "should raise an error"
    rescue
      assert true
    end
  end

  def test_out_trade_no_length
    begin
      Weixin::App.prepay_id({'bank_type' => '', 'body' => '', 'fee_type' => '',
                             'input_charset' => '', 'notify_url' => '', 'out_trade_no' => '',
                             'spbill_create_ip' => ''}, '123')
      assert false, "should raise an error"
    rescue
      assert true
    end
  end

  def test_total_fee_params
    begin
      Weixin::App.prepay_id({'bank_type' => '', 'body' => '', 'fee_type' => '',
                             'input_charset' => '', 'notify_url' => '', 'out_trade_no' => '123456789',
                             'spbill_create_ip' => ''}, '123')
      assert false, "should raise an error"
    rescue
      assert true
    end
  end
end
