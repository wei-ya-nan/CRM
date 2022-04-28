package com.wyn.crm.web.controller;

import com.wyn.crm.entity.FunnelVO;
import com.wyn.crm.service.api.TranService;
import com.wyn.crm.utils.ResultEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/28
 */
@Controller
public class ChartController {

    @Autowired
    private TranService tranService;
    @RequestMapping("/chart/transaction/index.html")
    public String index(){
        //跳转页面
        return "workbench/chart/transaction/index";
    }

    @RequestMapping("/workbench/chart/transaction/tranGroupByStage.json")
    public @ResponseBody Object queryCountOfTranGroupByStage(){
        //调用service层方法，查询数据
        List<FunnelVO> funnelVOList=tranService.queryCountOfTranGroupByStage();
        //根据查询结果，返回响应信息
        return funnelVOList;
    }
}
