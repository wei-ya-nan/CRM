package com.wyn.crm.service.api;

import com.wyn.crm.entity.DicValue;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/25
 */
public interface DicValueService {
    List<DicValue> queryDicValueByTypeCode(@Param("stage") String stage);
}
