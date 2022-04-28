package com.wyn.crm.service.impl;

import com.wyn.crm.entity.TranHistory;
import com.wyn.crm.mapper.TranHistoryMapper;
import com.wyn.crm.service.api.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/27
 */
@Service
public class TranHistoryServiceImpl implements TranHistoryService {
    @Autowired
    private TranHistoryMapper tranHistoryMapper;

    public List<TranHistory> getAll() {
       List<TranHistory> list =  tranHistoryMapper.getAll();
        return list;
    }
}
