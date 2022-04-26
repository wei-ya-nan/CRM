package com.wyn.crm.service.impl;

import com.wyn.crm.entity.DicValue;
import com.wyn.crm.mapper.DicValueMapper;
import com.wyn.crm.service.api.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/25
 */
@Service
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    public List<DicValue>  queryDicValueByTypeCode(String stage) {
        List<DicValue> dicValues = dicValueMapper.queryDicValueByTypeCode(stage);
        return dicValues;
    }
}
